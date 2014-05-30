IF OBJECT_ID('dbo.wsp_getUserSubscriptionAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserSubscriptionAccount
    IF OBJECT_ID('dbo.wsp_getUserSubscriptionAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserSubscriptionAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserSubscriptionAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves user account info
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getUserSubscriptionAccount
@userId NUMERIC(12,0) 
AS
  BEGIN  
     SELECT subscriptionOfferDetailId,
            subscriptionStatus,
            subscriptionEndDate
         FROM UserSubscriptionAccount
         WHERE userId = @userId
         AT ISOLATION READ UNCOMMITTED
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getUserSubscriptionAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserSubscriptionAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserSubscriptionAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserSubscriptionAccount TO web
go
