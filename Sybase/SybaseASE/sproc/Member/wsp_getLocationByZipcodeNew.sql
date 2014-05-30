IF OBJECT_ID('dbo.wsp_getLocationByZipcodeNew') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getLocationByZipcodeNew
   IF OBJECT_ID('dbo.wsp_getLocationByZipcodeNew') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByZipcodeNew >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByZipcodeNew >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan L 
**   Date:  Oct 24 2008
**   Description: Retrieves location info for a given zip code
**
** REVISION(S):
**   Author: 
**   Date:  
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE wsp_getLocationByZipcodeNew
   @postalCode VARCHAR(10)
AS

BEGIN
   SELECT @postalCode = LTRIM(RTRIM(UPPER(@postalCode)))

   SELECT c.countryId AS countryId,
          c.countryLabel AS countryName,
          j.jurisdictionId AS regionId, 
          j.jurisdictionName AS regionLabel,
          t.cityId AS cityId,
          t.cityName AS cityName
     FROM PostalZipCode_New p, Country c, Jurisdiction j, City_new t 
    WHERE p.zipcode = @postalCode
      AND p.cityId = t.cityId
      AND p.countryId = c.countryId
      AND p.jurisdictionId = j.jurisdictionId

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getLocationByZipcodeNew TO web
go

IF OBJECT_ID('dbo.wsp_getLocationByZipcodeNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByZipcodeNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByZipcodeNew >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLocationByZipcodeNew','unchained'
go
