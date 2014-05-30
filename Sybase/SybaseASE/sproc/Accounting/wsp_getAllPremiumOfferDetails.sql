IF OBJECT_ID('dbo.wsp_getAllPremiumOfferDetails') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllPremiumOfferDetails
    IF OBJECT_ID('dbo.wsp_getAllPremiumOfferDetails') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllPremiumOfferDetails >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllPremiumOfferDetails >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         November 2005
**   Description:  retrieves all premium offers
**
** REVISION:
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllPremiumOfferDetails
AS
    BEGIN  
        SELECT pmo.premiumOfferId
              ,pmo.premiumOfferTypeId
              ,pmo.premiumOfferMaskId
              ,pod.purchaseOfferDetailId
              ,pod.purchaseOfferId
              ,pod.contentId
              ,pod.ordinal
              ,pod.cost
              ,pod.credits
              ,pod.bonusCredits
              ,pod.duration
              ,pod.restrictedPurchaseTypeId
        FROM PremiumOffer pmo, PurchaseOfferDetail pod
        WHERE pmo.purchaseOfferDetailId = pod.purchaseOfferDetailId
        ORDER BY premiumOfferId
        
        RETURN @@error
    END
go

IF OBJECT_ID('dbo.wsp_getAllPremiumOfferDetails') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllPremiumOfferDetails >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllPremiumOfferDetails >>>'
go

GRANT EXECUTE ON dbo.wsp_getAllPremiumOfferDetails TO web
go
