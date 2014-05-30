IF OBJECT_ID('dbo.wsp_getCountryIdByIsoCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCountryIdByIsoCode
    IF OBJECT_ID('dbo.wsp_getCountryIdByIsoCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCountryIdByIsoCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCountryIdByIsoCode >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          August, 2006
**   Description:   Retrieves countryId by isoCode
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getCountryIdByIsoCode
 @countryCodeIso CHAR(2)
AS

BEGIN
    SELECT countryId, 
           countryLabel
      FROM Country
     WHERE countryCodeIso = @countryCodeIso
    
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCountryIdByIsoCode TO web
go

IF OBJECT_ID('dbo.wsp_getCountryIdByIsoCode') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCountryIdByIsoCode >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCountryIdByIsoCode >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCountryIdByIsoCode','unchained'
go
