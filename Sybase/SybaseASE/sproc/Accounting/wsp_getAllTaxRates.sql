IF OBJECT_ID('dbo.wsp_getAllTaxRates') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllTaxRates
    IF OBJECT_ID('dbo.wsp_getAllTaxRates') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllTaxRates >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllTaxRates >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         April, 2010
**   Description:  retrieves all tax rates
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getAllTaxRates
AS

DECLARE @dateNow DATETIME
SELECT @dateNow = getdate() -- local time

BEGIN
    SELECT countryId
          ,countryName
          ,NULL AS jurisdictionId
          ,NULL AS jurisdictionName
          ,taxRate
      FROM CountryTaxRate
     WHERE (dateExpired IS NULL OR dateExpired >= @dateNow)
       AND dateStarted <= @dateNow

    UNION

    SELECT c.countryId
          ,c.countryName
          ,j.jurisdictionId
          ,j.jurisdictionName
          ,j.taxRate
      FROM CountryTaxRate c, JurisdictionTaxRate j
     WHERE c.countryId = j.countryId
       AND (j.dateExpired IS NULL OR j.dateExpired >= @dateNow)
       AND j.dateStarted <= @dateNow

    ORDER BY countryId, jurisdictionId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getAllTaxRates TO web
go

IF OBJECT_ID('dbo.wsp_getAllTaxRates') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllTaxRates >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllTaxRates >>>'
go

EXEC sp_procxmode 'dbo.wsp_getAllTaxRates','unchained'
go
