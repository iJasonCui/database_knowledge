USE Accounting
go
IF OBJECT_ID('dbo.wsp_getDetailsByOfferId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDetailsByOfferId
    IF OBJECT_ID('dbo.wsp_getDetailsByOfferId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDetailsByOfferId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDetailsByOfferId >>>'
END
go
/******************************************************************************
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getDetailsByOfferId
@offerDetailId     INT
AS
   BEGIN  
      SELECT subscriptionOfferDetailId,
             subscriptionOfferId,
             contentId,
             subscriptionTypeId,
             ordinal,
             cost,
             duration,
             durationUnits,
             freeTrialDuration,
             dateExpiry,
             freeTrialDurationUnits,
             promoFlag,
             autoRenewOfferDetailId, 
             premiumId,
             masterOfferDetailId 
        FROM SubscriptionOfferDetail
        WHERE subscriptionOfferDetailId = @offerDetailId
      RETURN @@error
   END
go
EXEC sp_procxmode 'dbo.wsp_getDetailsByOfferId','unchained'
go
IF OBJECT_ID('dbo.wsp_getDetailsByOfferId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDetailsByOfferId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDetailsByOfferId >>>'
go
GRANT EXECUTE ON dbo.wsp_getDetailsByOfferId TO web
go
