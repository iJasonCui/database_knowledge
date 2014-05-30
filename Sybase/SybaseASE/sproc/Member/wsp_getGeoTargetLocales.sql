IF OBJECT_ID('dbo.wsp_getGeoTargetLocales') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGeoTargetLocales
    IF OBJECT_ID('dbo.wsp_getGeoTargetLocales') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGeoTargetLocales >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGeoTargetLocales >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          May 17, 2004
**   Description:   Retrieves all Geo-targeting locale
**
** REVISION(S):
**   Author:        Valeri Popov
**   Date:          Sep 16, 2004
**   Description:   Retrieves all Geo-targeting locale
**
** REVISION(S):
**   Author:
**   Date:
** Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getGeoTargetLocales
AS
BEGIN
    SELECT b.countryCodeIso, a.navigateLocaleId, a.dateStarted
    FROM GeoTargetLocale a, Country b
    where a.targetCountryId = b.countryId
    
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getGeoTargetLocales TO web
go

IF OBJECT_ID('dbo.wsp_getGeoTargetLocales') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGeoTargetLocales >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGeoTargetLocales >>>'
go

EXEC sp_procxmode 'dbo.wsp_getGeoTargetLocales','unchained'
go
