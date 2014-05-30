IF OBJECT_ID('dbo.wsp_getReactivateUsers') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getReactivateUsers
   IF OBJECT_ID('dbo.wsp_getReactivateUsers') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getReactivateUsers >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getReactivateUsers >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Date:  March 2009
**   Description:  retrieves all Active subscriptions between start and end timestamp.
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getReactivateUsers
@start   DATETIME, 
@end     DATETIME 
AS 

BEGIN
   SELECT DISTINCT s.userId 
     FROM UserSubscriptionAccount s, UserAccount u
    WHERE subscriptionStatus = 'A'
      AND autoRenew="N"
      AND u.userId=s.userId 
      --AND u.subscriptionOfferId in (9,10,11)
      AND subscriptionEndDate between @start and @end
      AND subscriptionOfferDetailId NOT IN(SELECT subscriptionOfferDetailId FROM SubscriptionOfferDetail 
                                            WHERE premiumId > 0)
   ORDER BY userId

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getReactivateUsers') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getReactivateUsers >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getReactivateUsers >>>'
go

GRANT EXECUTE ON dbo.wsp_getReactivateUsers TO web
go

