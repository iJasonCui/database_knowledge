IF OBJECT_ID('dbo.wsp_getUserAccountByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserAccountByUserId
    IF OBJECT_ID('dbo.wsp_getUserAccountByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserAccountByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserAccountByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan Liu 
**   Date:  April 2, 2008
**   Description:  retrieves user account info by userId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getUserAccountByUserId
   @userId NUMERIC(12, 0) 
AS
BEGIN  
   SELECT billingLocationId,
          accountType,
          purchaseOfferId,
          usageCellId,
          dateExpiry,
          subscriptionOfferId
     FROM UserAccount 
    WHERE userId = @userId 
   --AT ISOLATION READ UNCOMMITTED

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getUserAccountByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserAccountByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserAccountByUserId >>>'
go

GRANT EXECUTE ON dbo.wsp_getUserAccountByUserId TO web
go
