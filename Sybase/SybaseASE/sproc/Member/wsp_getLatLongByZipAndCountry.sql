IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByZipAndCountry
    IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByZipAndCountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByZipAndCountry >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author: Malay Dave
**   Date:  April 18 2005
**   Description: Retrieves latitude and longitude for a given zip code and countryId
**
******************************************************************************/

CREATE PROCEDURE wsp_getLatLongByZipAndCountry
@zipcode VARCHAR(10),
@countryId SMALLINT
AS

BEGIN
    SELECT lat_rad, long_rad
    FROM PostalZipCode
    WHERE zipcode = @zipcode
    AND countryId = @countryId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLatLongByZipAndCountry TO web
go
IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCountry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByZipAndCountry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByZipAndCountry >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLatLongByZipAndCountry','unchained'
go
