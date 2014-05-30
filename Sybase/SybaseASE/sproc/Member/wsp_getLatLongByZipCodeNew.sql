IF OBJECT_ID('dbo.wsp_getLatLongByZipCodeNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByZipCodeNew
    IF OBJECT_ID('dbo.wsp_getLatLongByZipCodeNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByZipCodeNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByZipCodeNew >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author: Jack Veiga
**   Date:  June 4 2002
**   Description: Retrieves latitude and longitude for a given zip code
**
** REVISION(S):
**   Author: Travis McCauley
**   Date:  June 24, 2004
**   Description: Use the PostalCode table
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  June 23, 2006
**   Description: also return cityId, jurisdictionId, and secondJurisdictionId
**
******************************************************************************/

CREATE PROCEDURE wsp_getLatLongByZipCodeNew
    @zipcode VARCHAR(10)
AS

BEGIN
    SELECT @zipcode = LTRIM(RTRIM(UPPER(@zipcode)))
    SELECT lat_rad, 
           long_rad,
           ISNULL(countryId,-1) AS countryId,
           ISNULL(cityId,-1) AS cityId,
           ISNULL(jurisdictionId,-1) AS jurisdictionId,
           ISNULL(secondJurisdictionId,-1) AS secondJurisdictionId
      FROM PostalZipCode_New
     WHERE zipcode = @zipcode

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getLatLongByZipCodeNew TO web
go

IF OBJECT_ID('dbo.wsp_getLatLongByZipCodeNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByZipCodeNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByZipCodeNew >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLatLongByZipCodeNew','unchained'
go
