IF OBJECT_ID('dbo.wsp_getLatLongByZipCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByZipCode
    IF OBJECT_ID('dbo.wsp_getLatLongByZipCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByZipCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByZipCode >>>'
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
** REVISION(S):
**   Author: F Schonberger
**   Date:  May 07, 2010
**   Description: find Canadian locations by the first 3 characters
**
******************************************************************************/

CREATE PROCEDURE wsp_getLatLongByZipCode
    @zipcode VARCHAR(10)
AS

BEGIN
   DECLARE @zipPrefix VARCHAR(10),
           @lat INT,
           @long INT,
           @countryId INT,
           @jurisdictionId INT,
           @secondJurisdictionId INT,
           @cityId INT

    SELECT @zipcode = STR_REPLACE(UPPER(@zipcode),' ',null)
    SELECT @zipPrefix = SUBSTRING(@zipcode,1,3) + "%"  

    -- try an exact match
    SELECT @lat = lat_rad, 
           @long = long_rad,
           @countryId = countryId,
           @cityId = cityId,
           @jurisdictionId = jurisdictionId,
           @secondJurisdictionId = secondJurisdictionId
      FROM PostalZipCode
     WHERE zipcode = @zipcode

     IF (@lat = NULL) 
     BEGIN
          -- only canadian postal codes
          IF (@zipcode LIKE "[A-Z][0-9][A-Z][0-9][A-Z][0-9]" )
              BEGIN 
                  SELECT @lat = convert(int,AVG(convert(numeric(10,4),lat_rad))),
                         @long =convert(int,AVG(convert(numeric(10,4),long_rad)))
                    FROM PostalZipCode (index XPKPostalCode)
                   WHERE zipcode LIKE @zipPrefix 
              END 
     END

     IF (@cityId = NULL) 
     BEGIN
          -- only canadian postal codes
          IF (@zipcode LIKE "[A-Z][0-9][A-Z][0-9][A-Z][0-9]" )
              BEGIN 
                  SELECT TOP 1 
                         @countryId = ISNULL(countryId,-1),
                         @cityId = ISNULL(cityId,-1),
                         @jurisdictionId = ISNULL(jurisdictionId,-1),
                         @secondJurisdictionId = ISNULL(secondJurisdictionId,-1)
                    FROM PostalZipCode
                   WHERE zipcode LIKE @zipPrefix 
                     AND cityId > 0
              END 
     END   

    SELECT @lat AS lat_rad, 
           @long AS long_rad,
           ISNULL(@countryId,-1) AS countryId,
           ISNULL(@cityId,-1) AS cityId,
           ISNULL(@jurisdictionId,-1) AS jurisdictionId,
           ISNULL(@secondJurisdictionId,-1) AS secondJurisdictionId

    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getLatLongByZipCode','unchained'
go
IF OBJECT_ID('dbo.wsp_getLatLongByZipCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByZipCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByZipCode >>>'
go
GRANT EXECUTE ON dbo.wsp_getLatLongByZipCode TO web
go
 
