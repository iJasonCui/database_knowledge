IF OBJECT_ID('dbo.wsp_getAllSubscripOfferDetails') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllSubscripOfferDetails
    IF OBJECT_ID('dbo.wsp_getAllSubscripOfferDetails') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllSubscripOfferDetails >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllSubscripOfferDetails >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Nov 2004
**   Description:  retrieves all subscription detail descriptions
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Jan 6, 2006
**   Description: retrieve extra columns
**
** REVISION(S):
**   Author: Yan Liu 
**   Date: Feb 26, 2008
**   Description: retrieve extra columns
**
** REVISION(S):
**   Author: Yan Liu 
**   Date: April 1, 2008
**   Description: retrieve extra columns - premiumId, masterOfferDetailId.
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllSubscripOfferDetails
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
      ORDER BY subscriptionOfferDetailId
      RETURN @@error
   END
go

IF OBJECT_ID('dbo.wsp_getAllSubscripOfferDetails') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllSubscripOfferDetails >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllSubscripOfferDetails >>>'
go

GRANT EXECUTE ON dbo.wsp_getAllSubscripOfferDetails TO web
go

