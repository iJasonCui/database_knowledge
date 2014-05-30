IF OBJECT_ID('dbo.wsp_getUserAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserAccount
    IF OBJECT_ID('dbo.wsp_getUserAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserAccount >>>'
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
** REVISION(S):
**   Author:  Andy Tran
**   Date:  Nov. 11, 2004
**   Description:  added dateExpiry
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 23, 2004
**   Description: also retrieve subscription info
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Jan 6, 2006
**   Description: also retrieve subscriptionOfferId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getUserAccount
@userId NUMERIC(12,0) 
AS
  BEGIN  
     SELECT billingLocationId,
            accountType,
            purchaseOfferId,
            usageCellId,
            dateExpiry,
            subscriptionOfferDetailId,
            subscriptionStatus,
            autoRenew,
            subscriptionEndDate,
            cardId,
            subscriptionOfferId
         FROM UserAccount u,UserSubscriptionAccount s
         WHERE u.userId = @userId AND u.userId *= s.userId
         AT ISOLATION READ UNCOMMITTED
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserAccount TO web
go
