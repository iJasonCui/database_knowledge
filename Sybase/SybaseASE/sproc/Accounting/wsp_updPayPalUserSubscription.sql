IF OBJECT_ID('dbo.wsp_updPayPalUserSubscription') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPayPalUserSubscription
    IF OBJECT_ID('dbo.wsp_updPayPalUserSubscription') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPayPalUserSubscription >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPayPalUserSubscription >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Inserts row into PayPalUserSubscription
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_updPayPalUserSubscription
 @userId                    NUMERIC(12,0)
,@recurringProfileId        VARCHAR(14)
,@subscriptionOfferDetailId SMALLINT
,@subscriptionStatus        CHAR(1)
,@subscriptionEndDate       DATETIME
,@cancelCodeId              TINYINT
,@cancelCodeMask            INT
,@userCancelReason          VARCHAR(255)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM PayPalUserSubscription WHERE recurringProfileId = @recurringProfileId)
    BEGIN
	    BEGIN TRAN TRAN_updPayPalUserSubscription
	        UPDATE PayPalUserSubscription
	           SET subscriptionOfferDetailId = @subscriptionOfferDetailId
	              ,subscriptionStatus = @subscriptionStatus
	              ,subscriptionEndDate = @subscriptionEndDate
	              ,dateModified = @dateNow
	         WHERE recurringProfileId = @recurringProfileId
	        
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updPayPalUserSubscription
                    RETURN 99
                END

            INSERT INTO PayPalUserSubscriptionHistory
            SELECT  userId
                   ,recurringProfileId
                   ,subscriptionOfferDetailId
                   ,subscriptionStatus
                   ,subscriptionEndDate
                   ,dateCreated
                   ,dateModified
                   ,@cancelCodeId
                   ,@cancelCodeMask
                   ,@userCancelReason
              FROM PayPalUserSubscription
             WHERE recurringProfileId = @recurringProfileId
              
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updPayPalUserSubscription
                    RETURN 98
                END

            COMMIT TRAN TRAN_updPayPalUserSubscription
            RETURN 0
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_newPayPalUserSubscription
            INSERT INTO PayPalUserSubscription (
                 userId
                ,recurringProfileId
                ,subscriptionOfferDetailId
                ,subscriptionStatus
                ,subscriptionEndDate
                ,dateCreated
                ,dateModified
            )
            VALUES (
                 @userId
                ,@recurringProfileId
                ,@subscriptionOfferDetailId
                ,@subscriptionStatus
                ,@subscriptionEndDate
                ,@dateNow
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_newPayPalUserSubscription
                    RETURN 99
                END

            INSERT INTO PayPalUserSubscriptionHistory
            SELECT  userId
                   ,recurringProfileId
                   ,subscriptionOfferDetailId
                   ,subscriptionStatus
                   ,subscriptionEndDate
                   ,dateCreated
                   ,dateModified
                   ,@cancelCodeId
                   ,@cancelCodeMask
                   ,@userCancelReason
              FROM PayPalUserSubscription
             WHERE recurringProfileId = @recurringProfileId
              
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_newPayPalUserSubscription
                    RETURN 98
                END

            COMMIT TRAN TRAN_newPayPalUserSubscription
            RETURN 0
    END
go

GRANT EXECUTE ON dbo.wsp_updPayPalUserSubscription TO web
go

IF OBJECT_ID('dbo.wsp_updPayPalUserSubscription') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updPayPalUserSubscription >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updPayPalUserSubscription >>>'
go

EXEC sp_procxmode 'dbo.wsp_updPayPalUserSubscription','unchained'
go
