
IF OBJECT_ID('dbo.wsp_adminAssignSubscription') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminAssignSubscription
    IF OBJECT_ID('dbo.wsp_adminAssignSubscription') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminAssignSubscription >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminAssignSubscription >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  August 2009
**   Description:  assign an admin subsciption for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminAssignSubscription
 @userId NUMERIC(12,0)
,@duration SMALLINT
,@durationUnits CHAR(1)
,@xactionTypeId TINYINT
,@subscriptionTypeId TINYINT
,@adminUserId INT
,@contentId SMALLINT
,@reason VARCHAR(255)
,@subscriptionEndDate DATETIME
,@subscriptionStatus CHAR(1)

AS

DECLARE
 @return                 INT
,@xactionId              INT
,@dateNow                DATETIME
,@oldSubscriptionEndDate DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF NOT EXISTS (SELECT 1 FROM UserSubscriptionAccount WHERE userId = @userId)
    BEGIN
        IF (@subscriptionEndDate IS NULL)
            BEGIN
                SELECT @subscriptionEndDate = DATEADD(ss, @duration*2592000, @dateNow) -- default months
                IF (@durationUnits = 'd')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*86400, @dateNow) -- days
                    END 
                IF (@durationUnits = 'h')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*3600, @dateNow) -- hours
                    END 
                IF (@durationUnits = 'm')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*60, @dateNow) -- minutes
                    END 
            END 

        IF (@subscriptionEndDate IS NULL OR @subscriptionEndDate <= @dateNow)
            BEGIN
                return 99
            END 

        BEGIN TRAN TRAN_adminAssignSubscription

            INSERT INTO UserSubscriptionAccount (
                 userId
                ,cardId
                ,subscriptionOfferDetailId
                ,subscriptionStatus
                ,autoRenew
                ,subscriptionEndDate
                ,dateCreated
                ,dateModified
            ) VALUES (
                 @userId
                ,-1
                ,0
                ,'A'
                ,'N'
                ,@subscriptionEndDate
                ,@dateNow
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 98
                END

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

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 97
                END

            INSERT INTO SubscriptionTransaction (
                 xactionId
                ,cardId
                ,userId
                ,xactionTypeId
                ,contentId
                ,subscriptionTypeId
                ,duration
                ,userTrans
                ,description
                ,dateCreated
                ,durationUnits
                ,subscriptionOfferDetailId
            ) VALUES (
                 @xactionId
                ,-1
                ,@userId
                ,@xactionTypeId
                ,@contentId
                ,@subscriptionTypeId
                ,@duration
                ,0
                ,@reason
                ,@dateNow
                ,@durationUnits
                ,0
            )
                
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 96
                END

            IF (@adminUserId > 0)
                BEGIN
                    INSERT INTO AdminAccountTransaction (
                         xactionId
                        ,adminUserId
                        ,userId
                        ,dateCreated
                    ) VALUES (
                         @xactionId
                        ,@adminUserId
                        ,@userId
                        ,@dateNow
                    )

                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_adminAssignSubscription
                            RETURN 96
                        END
                END

            COMMIT TRAN TRAN_adminAssignSubscription
            RETURN 0
    END
ELSE
    BEGIN
        IF (@subscriptionEndDate IS NULL)
            BEGIN
                SELECT @oldSubscriptionEndDate = subscriptionEndDate
                  FROM UserSubscriptionAccount
                 WHERE userId = @userId
        
                IF (@oldSubscriptionEndDate IS NULL OR @oldSubscriptionEndDate <= @dateNow)
                    BEGIN
                        SELECT @oldSubscriptionEndDate = @dateNow
                    END 
        
                SELECT @subscriptionEndDate = DATEADD(ss, @duration*2592000, @oldSubscriptionEndDate) -- default months
                IF (@durationUnits = 'd')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*86400, @oldSubscriptionEndDate) -- days
                    END 
                IF (@durationUnits = 'h')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*3600, @oldSubscriptionEndDate) -- hours
                    END 
                IF (@durationUnits = 'm')
                    BEGIN
                        SELECT @subscriptionEndDate = DATEADD(ss, @duration*60, @oldSubscriptionEndDate) -- minutes
                    END 
            END 

        IF (@subscriptionEndDate IS NULL OR @subscriptionEndDate <= @dateNow)
            BEGIN
                return 95
            END 

        IF (@subscriptionStatus IS NULL)
            BEGIN
	            SELECT @subscriptionStatus = 'A'
            END 

        BEGIN TRAN TRAN_adminAssignSubscription

            UPDATE UserSubscriptionAccount
               SET subscriptionStatus  = @subscriptionStatus
                  ,subscriptionEndDate = @subscriptionEndDate
                  ,dateModified = @dateNow
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 94
                END

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

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 93
                END

            INSERT INTO SubscriptionTransaction (
                 xactionId
                ,cardId
                ,userId
                ,xactionTypeId
                ,contentId
                ,subscriptionTypeId
                ,duration
                ,userTrans
                ,description
                ,dateCreated
                ,durationUnits
                ,subscriptionOfferDetailId
            ) VALUES (
                 @xactionId
                ,-1
                ,@userId
                ,@xactionTypeId
                ,@contentId
                ,@subscriptionTypeId
                ,@duration
                ,0
                ,@reason
                ,@dateNow
                ,@durationUnits
                ,0
            )
                
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_adminAssignSubscription
                    RETURN 92
                END

            IF (@adminUserId > 0)
                BEGIN
                    INSERT INTO AdminAccountTransaction (
                         xactionId
                        ,adminUserId
                        ,userId
                        ,dateCreated
                    ) VALUES (
                         @xactionId
                        ,@adminUserId
                        ,@userId
                        ,@dateNow
                    )

                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_adminAssignSubscription
                            RETURN 96
                        END
                END

            COMMIT TRAN TRAN_adminAssignSubscription
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_adminAssignSubscription') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminAssignSubscription >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminAssignSubscription >>>'
go

GRANT EXECUTE ON dbo.wsp_adminAssignSubscription TO web
go
