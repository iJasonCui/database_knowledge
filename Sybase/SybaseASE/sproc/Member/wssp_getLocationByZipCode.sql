IF OBJECT_ID('dbo.wssp_getLocationByZipCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getLocationByZipCode
    IF OBJECT_ID('dbo.wssp_getLocationByZipCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getLocationByZipCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getLocationByZipCode >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: F Schonberger
**   Date:  Oct, 2010
**   Description: Find a location by postal code.
**   This stored procedure is not an exact clone of wsp_getLocationByZipCode:
**   - it returns all location information, i.e. ids and names 
**   - finds Canadian locations by the first 3 characters
**
******************************************************************************/

CREATE PROCEDURE wssp_getLocationByZipCode
    @zipcode VARCHAR(10)
AS

BEGIN
   DECLARE @zipPrefix VARCHAR(10),
           @strippedZipCode VARCHAR(10),
           @lat INT,
           @long INT,
           @countryId INT,
           @countryISOCode CHAR(2),
           @countryName VARCHAR(100),
           @jurisdictionId INT,
           @jurisdictionName VARCHAR(100),
           @secondJurisdictionId INT,
           @secondJurisdictionName VARCHAR(100),
           @cityId INT,
           @cityName VARCHAR(120)

    SELECT @zipcode = UPPER(@zipcode)
    SELECT @strippedZipCode = STR_REPLACE(UPPER(@zipcode),' ',null)
    SELECT @zipPrefix = SUBSTRING(@strippedZipCode,1,3) + "%"  

    -- try an exact match
    SELECT @lat = lat_rad, 
           @long = long_rad,
           @countryId = countryId,
           @cityId = cityId,
           @jurisdictionId = jurisdictionId,
           @secondJurisdictionId = secondJurisdictionId
      FROM PostalZipCode
     WHERE zipcode IN (@zipcode, @strippedZipCode) 

     IF (@lat = NULL) 
     BEGIN
          -- calculate average lat, long from all records that match the zip prefix
          -- only canadian postal codes
          IF (@strippedZipCode LIKE "[A-Z][0-9][A-Z][0-9][A-Z][0-9]" )
              BEGIN 
                  SELECT @lat = convert(int,AVG(convert(numeric(10,4),lat_rad))),
                         @long =convert(int,AVG(convert(numeric(10,4),long_rad)))
                    FROM PostalZipCode (index XPKPostalCode)
                   WHERE zipcode LIKE @zipPrefix 
              END 
     END

     IF (@cityId = NULL) 
     BEGIN
          -- consider the first city that matches the zip prefix
          -- only canadian postal codes
          IF (@strippedZipCode LIKE "[A-Z][0-9][A-Z][0-9][A-Z][0-9]" )
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

     IF (@cityId > 0) 
     BEGIN
          SELECT @cityName = cityName
          FROM City
          WHERE cityId = @cityId
     END

     IF (@secondJurisdictionId > 0) 
     BEGIN
          SELECT @secondJurisdictionName = jurisdictionName
          FROM Jurisdiction
          WHERE jurisdictionId = @secondJurisdictionId
     END

     IF (@jurisdictionId > 0) 
     BEGIN
          SELECT @jurisdictionName = jurisdictionName
          FROM Jurisdiction
          WHERE jurisdictionId = @jurisdictionId
     END 
     
     IF (@countryId > 0) 
     BEGIN
          SELECT @countryName = countryLabel,
                 @countryISOCode = countryCodeIso
          FROM Country
          WHERE countryId = @countryId
     END
     
     SELECT @lat AS lat_rad, 
            @long AS long_rad,
            ISNULL(@countryId,-1) AS countryId,
            @countryISOCode AS countryCodeIso,
            @countryName AS countryName,
            ISNULL(@jurisdictionId,-1) AS jurisdictionId,
            @jurisdictionName AS jurisdictionName,
            ISNULL(@secondJurisdictionId,-1) AS secondJurisdictionId,
            @secondJurisdictionName AS secondJurisdictionName,           
            ISNULL(@cityId,-1) AS cityId,
            @cityName AS cityName

    RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wssp_getLocationByZipCode','unchained'
go
IF OBJECT_ID('dbo.wssp_getLocationByZipCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getLocationByZipCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getLocationByZipCode >>>'
go
GRANT EXECUTE ON dbo.wssp_getLocationByZipCode TO web
go

