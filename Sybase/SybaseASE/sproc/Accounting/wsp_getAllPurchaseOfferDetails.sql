IF OBJECT_ID('dbo.wsp_getAllPurchaseOfferDetails') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllPurchaseOfferDetails
    IF OBJECT_ID('dbo.wsp_getAllPurchaseOfferDetails') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllPurchaseOfferDetails >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllPurchaseOfferDetails >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         May 21, 2003
**   Description:  retrieves all package descriptions
**
** REVISION:
**   Author:       Andy Tran
**   Date:         Nov 15, 2004
**   Description:  remove purchaseOfferId from order by
**
**   Author:       Mike Stairs
**   Date:         Apr 29, 2005
**   Description:  add dateExpiry check
**
**   Author:       Andy Tran
**   Date:         Dec 1, 2005
**   Description:  returns all offer details, including expired
**                 filter out expired details when set detail list for offer
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllPurchaseOfferDetails
AS
  BEGIN  
	SELECT 
          purchaseOfferDetailId,
          purchaseOfferId,
          contentId,
          ordinal,
          cost,
          credits,
          bonusCredits,
          duration,
          restrictedPurchaseTypeId,
          dateExpiry
        FROM PurchaseOfferDetail
        ORDER BY purchaseOfferDetailId
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllPurchaseOfferDetails') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllPurchaseOfferDetails >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllPurchaseOfferDetails >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllPurchaseOfferDetails TO web
go

