IF OBJECT_ID('dbo.tsp_updUserAccountCreditOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_updUserAccountCreditOffer
END
go

CREATE PROCEDURE dbo.tsp_updUserAccountCreditOffer
 @billingLocationId   SMALLINT
,@purchaseOfferId_new SMALLINT

AS

DECLARE
 @dateNow         DATETIME
,@userId          NUMERIC(12,0)
,@purchaseOfferId SMALLINT
,@error           INT
,@rowcount        INT
,@total_rowcount  INT
,@message         VARCHAR(255)
,@return          INT
,@debug           TINYINT

-- SET DEBUG
SELECT @debug = 0

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    IF (@debug = 1) SET ROWCOUNT 2 ELSE SET ROWCOUNT 0

    -- select userId into tempdb
    INSERT INTO tempdb..UserAccount_migrateCredit
    SELECT userId, billingLocationId, purchaseOfferId
      FROM UserAccount
     WHERE billingLocationId = @billingLocationId
       AND purchaseOfferId != @purchaseOfferId_new

    IF (@@error != 0)
        BEGIN
            SELECT @message = 'Error: there is something wrong populating tempdb..UserAccount_migrate'
            PRINT @message
            RETURN 99
        END 

    DECLARE CUR_UserAccount_migrate CURSOR FOR
    SELECT userId, purchaseOfferId FROM tempdb..UserAccount_migrateCredit WHERE billingLocationId = @billingLocationId
    FOR READ ONLY

    OPEN CUR_UserAccount_migrate
    FETCH CUR_UserAccount_migrate INTO @userId, @purchaseOfferId

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
	        IF (@purchaseOfferId = @purchaseOfferId_new)
                 BEGIN
                    SELECT @message = 'Account for userId: ' + CONVERT(VARCHAR, @userId) + ' was already migrated!'
                    PRINT @message
                    FETCH CUR_UserAccount_migrate INTO @userId, @purchaseOfferId
                    CONTINUE
                 END 

            IF (@debug = 1)
                 BEGIN
                    SELECT @message = 'Migrating account for userId: ' + CONVERT(VARCHAR, @userId) + ', purchaseOfferId: ' +
                                      CONVERT(VARCHAR, @purchaseOfferId) + ' --> ' + CONVERT(VARCHAR, @purchaseOfferId_new)
                    PRINT @message
                 END

            SELECT @total_rowcount = @total_rowcount + 1
            IF (@total_rowcount != 0 and @total_rowcount % 10000 = 0)
                PRINT '%1! records have been processed.', @total_rowcount 

            -- begin transaction
            BEGIN TRAN TRAN_UserAccount_migrate
                -- update UserAccount
                UPDATE UserAccount
                   SET purchaseOfferId = @purchaseOfferId_new
                      ,dateModified = @dateNow
                 WHERE userId = @userId

                IF (@@error != 0)
                    BEGIN
                        ROLLBACK TRAN TRAN_UserAccount_migrate
                        SELECT @message = 'ERROR: cannot run query: UPDATE UserAccount ... for user: ' + CONVERT(VARCHAR, @userId)
                        PRINT @message
                        FETCH CUR_UserAccount_migrate INTO @userId, @purchaseOfferId
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
                        SELECT @message = 'ERROR: cannot run query: INSERT INTO UserAccountHistory ... for user: ' + CONVERT(VARCHAR, @userId)
                        PRINT @message
                        FETCH CUR_UserAccount_migrate INTO @userId, @purchaseOfferId
                        CONTINUE
                    END

                -- commit transaction
                COMMIT TRAN TRAN_UserAccount_migrate

                FETCH CUR_UserAccount_migrate INTO @userId, @purchaseOfferId
        END

    CLOSE CUR_UserAccount_migrate
    DEALLOCATE CURSOR CUR_UserAccount_migrate
    SET ROWCOUNT 0
END
go
