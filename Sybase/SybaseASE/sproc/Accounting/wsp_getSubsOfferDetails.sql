IF OBJECT_ID('dbo.wsp_getSubsOfferDetails') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSubsOfferDetails
    IF OBJECT_ID('dbo.wsp_getSubsOfferDetails') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubsOfferDetails >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubsOfferDetails >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jeff Yang
**   Date:  August 2008
**   Description:  Retrieves all subscription detail descriptions
**                 order by ordinal (difference from wsp_getSubscrOfferDetails)
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  April 2009
**   Description: Added upgradeOfferDetailId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSubsOfferDetails
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
             masterOfferDetailId,
             upgradeOfferDetailId
        FROM SubscriptionOfferDetail
      ORDER BY ordinal
      RETURN @@error
   END
go

IF OBJECT_ID('dbo.wsp_getSubsOfferDetails') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubsOfferDetails >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubsOfferDetails >>>'
go

GRANT EXECUTE ON dbo.wsp_getSubsOfferDetails TO web
go

