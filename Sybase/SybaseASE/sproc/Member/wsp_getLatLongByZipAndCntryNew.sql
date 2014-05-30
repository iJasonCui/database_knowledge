IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCntryNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByZipAndCntryNew
    IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCntryNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByZipAndCntryNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByZipAndCntryNew >>>'
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

CREATE PROCEDURE wsp_getLatLongByZipAndCntryNew
@zipcode VARCHAR(10),
@countryId SMALLINT
AS

BEGIN
    SELECT lat_rad, long_rad
    FROM PostalZipCode_New
    WHERE zipcode = @zipcode
    AND countryId = @countryId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLatLongByZipAndCntryNew TO web
go
IF OBJECT_ID('dbo.wsp_getLatLongByZipAndCntryNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByZipAndCntryNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByZipAndCntryNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLatLongByZipAndCntryNew','unchained'
go
