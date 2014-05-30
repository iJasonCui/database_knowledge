use Accounting
go
IF OBJECT_ID('dbo.wsp_getExpiredFreemiumSubs') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getExpiredFreemiumSubs
   IF OBJECT_ID('dbo.wsp_getExpiredFreemiumSubs') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getExpiredFreemiumSubs >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getExpiredFreemiumSubs >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Andy Tran 
**   Date:  October 2011
**   Description:  Retrieves expired freemium subscriptions since @dateCutoff.
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getExpiredFreemiumSubs
 @dateCutoff DATETIME
AS

BEGIN
    SELECT usa.userId,
           usa.subscriptionOfferDetailId,
           usa.subscriptionEndDate,
           sod.premiumId
      FROM UserSubscriptionAccount usa, SubscriptionOfferDetail sod
     WHERE usa.subscriptionOfferDetailId = sod.subscriptionOfferDetailId
       AND usa.subscriptionStatus = 'I'
       AND usa.subscriptionEndDate >= @dateCutoff
       AND sod.premiumId IN (6, 7, 8)
    ORDER BY userId

    RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getExpiredFreemiumSubs') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getExpiredFreemiumSubs >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getExpiredFreemiumSubs >>>'
go

GRANT EXECUTE ON dbo.wsp_getExpiredFreemiumSubs TO web
go

