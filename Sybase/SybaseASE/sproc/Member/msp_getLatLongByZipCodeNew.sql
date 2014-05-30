IF OBJECT_ID('dbo.msp_getLatLongByZipCodeNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getLatLongByZipCodeNew
    IF OBJECT_ID('dbo.msp_getLatLongByZipCodeNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getLatLongByZipCodeNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getLatLongByZipCodeNew >>>'
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

CREATE PROCEDURE msp_getLatLongByZipCodeNew
    @zipcode VARCHAR(10)
AS

BEGIN
    SELECT lat_rad, 
           long_rad,
           ISNULL(countryId,-1),
           ISNULL(cityId,-1),
           ISNULL(jurisdictionId,-1),
           ISNULL(secondJurisdictionId,-1)
      FROM PostalZipCode_New
     WHERE zipcode = @zipcode

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.msp_getLatLongByZipCodeNew TO web
go

IF OBJECT_ID('dbo.msp_getLatLongByZipCodeNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_getLatLongByZipCodeNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getLatLongByZipCodeNew >>>'
go

EXEC sp_procxmode 'dbo.msp_getLatLongByZipCodeNew','unchained'
go
