IF OBJECT_ID('dbo.wsp_updUserAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserAccount
    IF OBJECT_ID('dbo.wsp_updUserAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  updates user account info
**
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  August 2009
**   Description:  added subscriptionOfferId
**
**   Author:  Andy Tran
**   Date:  November 2009
**   Description:  check current account type
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserAccount
 @userId              NUMERIC(12,0)
,@billingLocationId   SMALLINT
,@accountType         CHAR(1)
,@purchaseOfferId     SMALLINT
,@usageCellId         SMALLINT
,@subscriptionOfferId SMALLINT

AS
DECLARE
 @dateNow            DATETIME
,@currentAccountType CHAR(1)
,@return             INT  

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM UserAccount WHERE userId = @userId)
    BEGIN
	    IF (@purchaseOfferId IS NULL)
            BEGIN
	            SELECT @purchaseOfferId = defaultPurchaseOfferId
	              FROM DefaultUserAccount
	             WHERE billingLocationId = @billingLocationId
            END 

        IF (@usageCellId IS NULL)
            BEGIN
                SELECT @usageCellId = defaultUsageCellId
                  FROM DefaultUserAccount
                 WHERE billingLocationId = @billingLocationId
            END 

        IF (@subscriptionOfferId IS NULL)
            BEGIN
                SELECT @subscriptionOfferId = defaultSubscriptionOfferId
                  FROM DefaultUserAccount
                 WHERE billingLocationId = @billingLocationId
            END 

        IF (@accountType = 'O')
            BEGIN
                SELECT @currentAccountType = accountType
                  FROM UserAccount
                 WHERE userId = @userId
                
                 IF (@currentAccountType = 'C')
                     BEGIN
	                     SELECT @subscriptionOfferId = NULL
                     END 
            END

        BEGIN TRAN TRAN_updUserAccount

            UPDATE UserAccount
               SET billingLocationId = @billingLocationId
                  ,accountType  = @accountType
                  ,purchaseOfferId = @purchaseOfferId
                  ,usageCellId  = @usageCellId
                  ,dateModified = @dateNow
                  ,dateExpiry = NULL
                  ,subscriptionOfferId = @subscriptionOfferId
             WHERE userId = @userId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updUserAccount
                    RETURN 99
                END

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

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updUserAccount
                    RETURN 98
                END

            COMMIT TRAN TRAN_updUserAccount
            RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_updUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserAccount >>>'
go

GRANT EXECUTE ON dbo.wsp_updUserAccount TO web
go

