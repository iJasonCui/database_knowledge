use Accounting
go
IF OBJECT_ID('dbo.wsp_getSubscriptionRenew') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getSubscriptionRenew
   IF OBJECT_ID('dbo.wsp_getSubscriptionRenew') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubscriptionRenew >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubscriptionRenew >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan Liu 
**   Date:  April 2008
**   Description:  retrieves all expired subscriptions, which are then either
**                 renewed or marked inactive.
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSubscriptionRenew
AS

BEGIN
   DECLARE @return  INT
   DECLARE @dateNow DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF @return != 0
   BEGIN
      RETURN @return
   END

    SELECT userId , autoRenew, cardId, subscriptionOfferDetailId, subscriptionStatus, subscriptionEndDate
    FROM UserSubscriptionAccount
    WHERE subscriptionStatus <> 'I'
      AND subscriptionEndDate < @dateNow
   ORDER BY userId

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getSubscriptionRenew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubscriptionRenew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubscriptionRenew >>>'
go

GRANT EXECUTE ON dbo.wsp_getSubscriptionRenew TO web
go

