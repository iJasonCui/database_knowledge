IF OBJECT_ID('dbo.wsp_getAllBillingLocations') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllBillingLocations
    IF OBJECT_ID('dbo.wsp_getAllBillingLocations') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllBillingLocations >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllBillingLocations >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all package descriptions
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: June 3, 2004
**   Description: return merchantId as well
**
**   Author: Mike Stairs
**   Date: June 24, 2005
**   Description: make sure TaxRate the current one
**
**   Author: Andy Tran
**   Date: September 27, 2005
**   Description: return displayPayPal
**
**   Author: Andy Tran
**   Date: November 15, 2006
**   Description: return displayInterac
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllBillingLocations
AS
  BEGIN  
	SELECT 
          BillingLocation.billingLocationId,
          billingLocationCode,
          billingLocationDesc,
          currencyId,
          displayTax,
          rate,
          merchantId,
          displayInterac,
          displayPayPal
        FROM BillingLocation,TaxRate
        WHERE BillingLocation.billingLocationId = TaxRate.billingLocationId AND TaxRate.dateExpired IS NULL
        ORDER BY billingLocationId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllBillingLocations') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllBillingLocations >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllBillingLocations >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllBillingLocations TO web
go

