IF OBJECT_ID('dbo.wsp_getCityByNameNew') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getCityByNameNew
   IF OBJECT_ID('dbo.wsp_getCityByNameNew') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityByNameNew >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityByNameNew >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author: Yan L 
**   Date:  Oct 24 2008
**   Description: Retrieves jurisdiction info by countryId, jurisdictionId, cityName 
**
** REVISION(S):
**   Author: 
**   Date:  
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE wsp_getCityByNameNew
   @countryId      SMALLINT,
   @jurisdictionId SMALLINT, 
   @cityName       VARCHAR(120)
AS

BEGIN
   SELECT @cityName = LTRIM(RTRIM(UPPER(@cityName)))

   SET ROWCOUNT 1
   SELECT cityId,
          cityName
     FROM City_new 
    WHERE countryId = @countryId
      AND jurisdictionId = @jurisdictionId
      AND UPPER(cityName) = @cityName 

   RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getCityByNameNew TO web
go

IF OBJECT_ID('dbo.wsp_getCityByNameNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityByNameNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityByNameNew >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCityByNameNew','unchained'
go
