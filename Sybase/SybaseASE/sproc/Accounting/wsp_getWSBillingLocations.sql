IF OBJECT_ID('dbo.wsp_getWSBillingLocations') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWSBillingLocations
    IF OBJECT_ID('dbo.wsp_getWSBillingLocations') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWSBillingLocations >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWSBillingLocations >>>'
END
go
/******************************************************************************
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getWSBillingLocations
AS
  BEGIN  
	SELECT 
          b.billingLocationId,
          billingLocationCode,
          billingLocationDesc,
          currencyId,
          displayTax,
          rate,
          merchantId,
          displayInterac,
          productId,
          d.defaultPurchaseOfferId, 
          d.defaultAccountType,
          d.defaultUsageCellId,
          d.defaultSubscriptionOfferId
        FROM BillingLocation b,TaxRate t, DefaultUserAccount d
        WHERE b.billingLocationId = t.billingLocationId AND b.billingLocationId = d.billingLocationId AND t.dateExpired IS NULL
        ORDER BY billingLocationId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getWSBillingLocations') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getWSBillingLocations >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWSBillingLocations >>>'
go
GRANT EXECUTE ON dbo.wsp_getWSBillingLocations TO web
go

