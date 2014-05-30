IF OBJECT_ID('dbo.wssp_getCountryByIsoCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getCountryByIsoCode
    IF OBJECT_ID('dbo.wssp_getCountryByIsoCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getCountryByIsoCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getCountryByIsoCode >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: F Schonberger
**   Date:  Oct, 2010
**   Description: Retrieves countryId by isoCode.
**   Cloned after wsp_getCountryIdByIsoCode
**
******************************************************************************/
CREATE PROCEDURE  wssp_getCountryByIsoCode
 @countryCodeIso CHAR(2)
AS

BEGIN
    SELECT countryId, 
           countryLabel AS countryName
      FROM Country
     WHERE countryCodeIso = @countryCodeIso
    
    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wssp_getCountryByIsoCode','unchained'
go
IF OBJECT_ID('dbo.wssp_getCountryByIsoCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getCountryByIsoCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getCountryByIsoCode >>>'
go
GRANT EXECUTE ON dbo.wssp_getCountryByIsoCode TO web
go
