IF OBJECT_ID('dbo.wsp_getAllPurchaseOffers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllPurchaseOffers
    IF OBJECT_ID('dbo.wsp_getAllPurchaseOffers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllPurchaseOffers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllPurchaseOffers >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all offers
**
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  January, 2007
**   Description:  add billingLocationId and baseOfferFlag
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllPurchaseOffers
AS
  BEGIN  
	SELECT 
          purchaseOfferId,
          currencyId,
          accountType,
          dateExpiry,
          description,
          billingLocationId,
          baseOfferFlag
        FROM PurchaseOffer
        ORDER BY purchaseOfferId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllPurchaseOffers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllPurchaseOffers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllPurchaseOffers >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllPurchaseOffers TO web
go

