IF OBJECT_ID('dbo.wsp_getUserSubAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserSubAccount
    IF OBJECT_ID('dbo.wsp_getUserSubAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserSubAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserSubAccount >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan Liu 
**   Date:  April 2, 2008
**   Description:  retrieves user subscription account info by userId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getUserSubAccount
   @userId NUMERIC(12, 0) 
AS
BEGIN  
   SELECT subscriptionOfferDetailId,
          subscriptionStatus,
          autoRenew,
          subscriptionEndDate,
          cardId 
     FROM UserSubscriptionAccount  
    WHERE userId = @userId 
   --AT ISOLATION READ UNCOMMITTED

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getUserSubAccount') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserSubAccount >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserSubAccount >>>'
go

GRANT EXECUTE ON dbo.wsp_getUserSubAccount TO web
go
