IF OBJECT_ID('dbo.wsp_updUserBillingLocation') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserBillingLocation
    IF OBJECT_ID('dbo.wsp_updUserBillingLocation') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserBillingLocation >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserBillingLocation >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Sept 29, 2003
**   Description:  Updates user billing location
**
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         January, 2007
**   Description:  Updates user purchase offer as well
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserBillingLocation
 @userId             NUMERIC(12,0)
,@billingLocationId  SMALLINT
AS

DECLARE
 @return             INT
,@dateNow            DATETIME
,@defaultOfferId     SMALLINT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updUserBillingLocation
    -- get initial offer
    SELECT @defaultOfferId = (SELECT defaultPurchaseOfferId FROM DefaultUserAccount WHERE billingLocationId = @billingLocationId)

    -- update user account
    UPDATE UserAccount
       SET billingLocationId = @billingLocationId
          ,purchaseOfferId = @defaultOfferId
          ,dateModified = @dateNow
     WHERE userId = @userId

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_updUserBillingLocation
            RETURN 99
        END

    -- delete any default offer
    DELETE FROM UserDefaultOffer
     WHERE userId = @userId

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_updUserBillingLocation
            RETURN 98
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
            ROLLBACK TRAN TRAN_updUserBillingLocation
            RETURN 97
        END
    ELSE
        BEGIN
            COMMIT TRAN TRAN_updUserBillingLocation
            RETURN 0
        END
go

IF OBJECT_ID('dbo.wsp_updUserBillingLocation') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserBillingLocation >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserBillingLocation >>>'
go

GRANT EXECUTE ON dbo.wsp_updUserBillingLocation TO web
go
