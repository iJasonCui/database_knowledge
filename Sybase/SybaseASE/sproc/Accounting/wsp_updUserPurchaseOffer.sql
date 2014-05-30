IF OBJECT_ID('dbo.wsp_updUserPurchaseOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserPurchaseOffer
    IF OBJECT_ID('dbo.wsp_updUserPurchaseOffer') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserPurchaseOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserPurchaseOffer >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         January, 2007
**   Description:  Update UserAccount purchaseOfferId for specified user
**                 Backup default purchaseOfferId in UserDefaultOffer
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserPurchaseOffer
 @userId           NUMERIC(12,0)
,@purchaseOfferId  SMALLINT
AS

DECLARE
 @return           INT
,@dateNow          DATETIME
,@defaultOfferId   SMALLINT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updUserPurchaseOffer
    -- get default offer from UserDefaultOffer
    SELECT @defaultOfferId = (SELECT purchaseOfferId FROM UserDefaultOffer WHERE userId = @userId)

    -- default offer exists
    IF (@defaultOfferId > 0)
        BEGIN
            -- case reset
            IF (@purchaseOfferId <= 0)
                BEGIN
                    SELECT @purchaseOfferId = @defaultOfferId
                END

            -- set purchase offer
            UPDATE UserAccount
               SET purchaseOfferId = @purchaseOfferId
                  ,subscriptionOfferId = NULL
                  ,accountType = 'C'
                  ,dateModified = @dateNow
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updUserPurchaseOffer
                    RETURN 99
                END

            -- case set
            IF (@purchaseOfferId = @defaultOfferId)
                BEGIN
                    -- delete default offer
                    DELETE FROM UserDefaultOffer
                     WHERE userId = @userId

                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_updUserPurchaseOffer
                            RETURN 98
                        END
                END
        END

    -- default offer does not exist
    ELSE
        BEGIN
            -- get default offer from UserAccount
            SELECT @defaultOfferId = (SELECT purchaseOfferId FROM UserAccount WHERE userId = @userId)

            -- if default offer is invalid then get from initial offer
            IF (@defaultOfferId <= 0)
                BEGIN
                    -- get initial offer
                    SELECT @defaultOfferId = (SELECT defaultPurchaseOfferId FROM DefaultUserAccount WHERE billingLocationId =
                                                 (SELECT billingLocationId FROM UserAccount WHERE userId = @userId)
                                             )
                END

            -- case reset
            IF (@purchaseOfferId <= 0)
                BEGIN
                    SELECT @purchaseOfferId = @defaultOfferId
                END

            -- case set
            IF (@purchaseOfferId != @defaultOfferId)
                BEGIN
                    -- save default offer
                    INSERT INTO UserDefaultOffer
                                (
                                     userId
                                    ,purchaseOfferId
                                    ,subscriptionOfferId
                                    ,usageCellId
                                    ,dateCreated
                                )
                         VALUES (
                                     @userId
                                    ,@defaultOfferId
                                    ,-1
                                    ,-1
                                    ,@dateNow
                                )

                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_updUserPurchaseOffer
                            RETURN 97
                        END
                 END

            -- set purchase offer
            UPDATE UserAccount
               SET purchaseOfferId = @purchaseOfferId
                  ,subscriptionOfferId = NULL
                  ,accountType = 'C'
                  ,dateModified = @dateNow
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updUserPurchaseOffer
                    RETURN 96
                END
        END

    -- save user account history
    INSERT INTO UserAccountHistory
                (
                     userId
                    ,billingLocationId
                    ,purchaseOfferId
                    ,subscriptionOfferId
                    ,usageCellId
                    ,accountType
                    ,dateCreated
                    ,dateModified
                    ,dateExpiry
                )
                SELECT userId
                      ,billingLocationId
                      ,purchaseOfferId
                      ,subscriptionOfferId
                      ,usageCellId
                      ,accountType
                      ,dateCreated
                      ,dateModified
                      ,dateExpiry
                  FROM UserAccount
                 WHERE userId = @userId

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_updUserPurchaseOffer
            RETURN 95
        END
    ELSE
        BEGIN
            COMMIT TRAN TRAN_updUserPurchaseOffer
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_updUserPurchaseOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserPurchaseOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updupdUserPurchaseOffer >>>'
go

GRANT EXECUTE ON dbo.wsp_updUserPurchaseOffer TO web
go
