IF OBJECT_ID('dbo.tsp_updUserAccountSubsOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_updUserAccountSubsOffer
END
go

CREATE PROCEDURE dbo.tsp_updUserAccountSubsOffer
 @billingLocationId            SMALLINT
,@subscriptionOfferId_rollout  SMALLINT
,@subscriptionOfferId_dialback SMALLINT

AS

DECLARE
 @dateNow         DATETIME
,@userId          NUMERIC(12,0)
,@error           INT
,@rowcount        INT
,@total_rowcount  INT
,@message         VARCHAR(255)
,@return          INT
,@debug           TINYINT

,@subscriptionOfferId           SMALLINT
,@subscriptionOfferId_new       SMALLINT
,@subscriptionOfferDetailId     SMALLINT
,@subscriptionOfferDetailId_new SMALLINT
,@duration                      SMALLINT
,@durationUnits                 CHAR(1)
,@cost                          NUMERIC(10,3)
,@cost_rollout                  NUMERIC(10,3)

-- SET DEBUG
SELECT @debug = 0

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    IF (@debug = 1) SET ROWCOUNT 2 ELSE SET ROWCOUNT 0

    -- select base price point
    SELECT @cost_rollout = cost
      FROM SubscriptionOfferDetail
     WHERE subscriptionOfferId = @subscriptionOfferId_rollout
       AND duration = 1 AND durationUnits = 'M'
       AND masterOfferDetailId = 0 AND upgradeOfferDetailId = 0

    -- select userId into tempdb
    INSERT INTO tempdb..UserAccount_migrateSubs
    SELECT userId, billingLocationId, subscriptionOfferId
      FROM UserAccount
     WHERE billingLocationId = @billingLocationId
       AND (accountType = 'S' OR (accountType = 'O' AND subscriptionOfferId IS NOT NULL))
       AND subscriptionOfferId NOT IN (@subscriptionOfferId_rollout, @subscriptionOfferId_dialback)

    IF (@@error != 0)
        BEGIN
            SELECT @message = 'Error: there is something wrong populating tempdb..UserAccount_migrate'
            PRINT @message
            RETURN 99
        END

    DECLARE CUR_UserAccount_migrate CURSOR FOR
    SELECT userId, subscriptionOfferId FROM tempdb..UserAccount_migrateSubs WHERE billingLocationId = @billingLocationId
    FOR READ ONLY

    OPEN CUR_UserAccount_migrate
    FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId

    SELECT @total_rowcount = 0

    WHILE @@sqlstatus != 2
        BEGIN
            IF @@sqlstatus = 1
                BEGIN
                    CLOSE CUR_UserAccount_migrate
                    DEALLOCATE CURSOR CUR_UserAccount_migrate
                    SELECT @message = 'ERROR: there is something wrong with CUR_UserAccount_migrate'
                    PRINT @message
                    RETURN 98
                END

            -- make sure correct user was selected
            IF (@subscriptionOfferId = @subscriptionOfferId_rollout OR @subscriptionOfferId = @subscriptionOfferId_dialback)
                 BEGIN
                    SELECT @message = 'Account for userId: ' + CONVERT(VARCHAR, @userId) + ' was already migrated!'
                    PRINT @message
                    FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                    CONTINUE
                 END 

            -- set price point
            SELECT @cost = cost
              FROM SubscriptionOfferDetail
             WHERE subscriptionOfferId = @subscriptionOfferId
               AND duration = 1 AND durationUnits = 'M'
               AND masterOfferDetailId = 0 AND upgradeOfferDetailId = 0

            SELECT @subscriptionOfferId_new = (CASE WHEN @cost > @cost_rollout
                                                    THEN @subscriptionOfferId_dialback
                                                    ELSE @subscriptionOfferId_rollout
                                               END)

            IF (@debug = 1)
                BEGIN
                    SELECT @message = 'Migrating account for userId: ' + CONVERT(VARCHAR, @userId) + ', subscriptionOfferId: ' +
                                      CONVERT(VARCHAR, @subscriptionOfferId) + ' --> ' + CONVERT(VARCHAR, @subscriptionOfferId_new)
                    PRINT @message
                END

            SELECT @total_rowcount = @total_rowcount + 1
            IF (@total_rowcount != 0 and @total_rowcount % 10000 = 0)
                PRINT '%1! records have been processed.', @total_rowcount 

            -- begin transaction
            BEGIN TRAN TRAN_UserAccount_migrate
                -- update UserAccount
                UPDATE UserAccount
                   SET subscriptionOfferId = @subscriptionOfferId_new
                      ,dateModified = @dateNow
                 WHERE userId = @userId

                IF (@@error != 0)
                    BEGIN
                        ROLLBACK TRAN TRAN_UserAccount_migrate
                        SELECT @message = 'ERROR: cannot run query: UPDATE UserAccount ... for user: ' + CONVERT(VARCHAR, @userId)
                        PRINT @message
                        FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                        CONTINUE
                    END

                -- insert UserAccountHistory
                INSERT INTO UserAccountHistory
                    SELECT userId
                          ,billingLocationId
                          ,purchaseOfferId
                          ,usageCellId
                          ,accountType
                          ,dateCreated
                          ,dateModified
                          ,dateExpiry
                          ,subscriptionOfferId 
                      FROM UserAccount 
                     WHERE userId = @userId

                IF (@@error != 0)
                    BEGIN
                        ROLLBACK TRAN TRAN_UserAccount_migrate
                        SELECT @message = 'ERROR: cannot run query: INSERT UserAccountHistory ... for user: ' + CONVERT(VARCHAR, @userId)
                        PRINT @message
                        FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                        CONTINUE
                    END

                -- update UserSubscriptionAccount
                IF EXISTS (SELECT 1 FROM UserSubscriptionAccount WHERE userId = @userId and subscriptionOfferDetailId = @subscriptionOfferDetailId)
                    BEGIN
                        SELECT @duration = duration
                              ,@durationUnits = durationUnits
                          FROM SubscriptionOfferDetail
                         WHERE subscriptionOfferId = @subscriptionOfferId
                           AND masterOfferDetailId = 0 AND upgradeOfferDetailId = 0

                        IF (@@error != 0)
                            BEGIN
                                ROLLBACK TRAN TRAN_UserAccount_migrate
                                SELECT @message = 'ERROR: cannot run query: SELECT duration ... for user: ' + CONVERT(VARCHAR, @userId)
                                PRINT @message
                                FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                                CONTINUE
                            END

                        SELECT @subscriptionOfferDetailId_new = subscriptionOfferDetailId
                          FROM SubscriptionOfferDetail
                         WHERE duration = @duration AND durationUnits = @durationUnits
                           AND masterOfferDetailId = 0 AND upgradeOfferDetailId = 0
                           AND subscriptionOfferId = @subscriptionOfferId_new

                        -- hack for California cells
                        IF (@subscriptionOfferDetailId_new IS NULL)
                            BEGIN
	                            SELECT @subscriptionOfferDetailId_new = subscriptionOfferDetailId
                                  FROM SubscriptionOfferDetail
                                 WHERE duration = (@duration + 1) AND durationUnits = @durationUnits
                                   AND masterOfferDetailId = 0 AND upgradeOfferDetailId = 0
                                   AND subscriptionOfferId = @subscriptionOfferId_new
	                        END
                        
                        IF (@@error != 0)
                            BEGIN
                                ROLLBACK TRAN TRAN_UserAccount_migrate
                                SELECT @message = 'ERROR: cannot run query: SELECT subscriptionOfferDetailId ... for user: ' + CONVERT(VARCHAR, @userId)
                                PRINT @message
                                FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                                CONTINUE
                            END

                        IF (@debug = 1)
                            BEGIN
                                SELECT @message = 'Migrating subscription account for userId: ' + CONVERT(VARCHAR, @userId) + ', subscriptionOfferDetailId: ' +
                                                  CONVERT(VARCHAR, @subscriptionOfferDetailId) + ' --> ' + CONVERT(VARCHAR, @subscriptionOfferDetailId_new)
                                PRINT @message
                            END

                        -- update UserSubscriptionAccount
                        UPDATE UserSubscriptionAccount
                           SET subscriptionOfferDetailId = @subscriptionOfferDetailId_new
                              ,dateModified = @dateNow
                         WHERE userId = @userId
                           AND subscriptionOfferDetailId = @subscriptionOfferDetailId

                        IF (@@error != 0)
                            BEGIN
                                ROLLBACK TRAN TRAN_UserAccount_migrate
                                SELECT @message = 'ERROR: cannot run query: UPDATE UserSubscriptionAccount ... for user: ' + CONVERT(VARCHAR, @userId)
                                PRINT @message
                                FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                                CONTINUE
                            END

                        -- insert UserSubscriptionAccountHistory
                        INSERT INTO UserSubscriptionAccountHistory
                            SELECT userId
                                  ,cardId
                                  ,subscriptionOfferDetailId
                                  ,subscriptionStatus
                                  ,autoRenew
                                  ,subscriptionEndDate
                                  ,0
                                  ,NULL
                                  ,dateCreated
                                  ,dateModified
                                  ,0
                              FROM UserSubscriptionAccount 
                             WHERE userId = @userId

                        IF (@@error != 0)
                            BEGIN
                                ROLLBACK TRAN TRAN_UserAccount_migrate
                                SELECT @message = 'ERROR: cannot run query: INSERT INTO UserSubscriptionAccountHistory ... for user: ' + CONVERT(VARCHAR, @userId)
                                PRINT @message
                                FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
                                CONTINUE
                            END
                    END

                -- commit transaction
                COMMIT TRAN TRAN_UserAccount_migrate
                
                FETCH CUR_UserAccount_migrate INTO @userId, @subscriptionOfferId
        END

    CLOSE CUR_UserAccount_migrate
    DEALLOCATE CURSOR CUR_UserAccount_migrate
    SET ROWCOUNT 0
END
go
