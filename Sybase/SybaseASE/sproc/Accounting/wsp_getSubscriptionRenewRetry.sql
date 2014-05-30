IF OBJECT_ID('dbo.wsp_getSubscriptionRenewRetry') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getSubscriptionRenewRetry
   IF OBJECT_ID('dbo.wsp_getSubscriptionRenewRetry') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubscriptionRenewRetry >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubscriptionRenewRetry >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan Liu 
**   Date:  July 30 2008
**   Description:  retrieves all retriable subscriptions, which are then either
**                 renewed or marked inactive.
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSubscriptionRenewRetry
   @status CHAR(1)
AS

BEGIN
   DECLARE @return  INT
   DECLARE @dateNow DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF @return != 0
   BEGIN
      RETURN @return
   END

   SELECT top 10 ua.userId , ua.autoRenew, ua.cardId, ua.subscriptionOfferDetailId, ua.subscriptionStatus, ua.subscriptionEndDate
   FROM UserSubscriptionAccount ua, RenewalRetryQueue rrq 
   WHERE ua.userId = rrq.userId 
     AND ua.subscriptionOfferDetailId = rrq.subscriptionOfferDetailId 
     AND subscriptionStatus <> 'I' 
     --AND subscriptionEndDate < @dateNow
     AND status = @status 
     AND nextRetryDate < @dateNow
     ORDER BY rrq.dateCreated DESC


   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getSubscriptionRenewRetry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubscriptionRenewRetry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubscriptionRenewRetry >>>'
go

GRANT EXECUTE ON dbo.wsp_getSubscriptionRenewRetry TO web
go

