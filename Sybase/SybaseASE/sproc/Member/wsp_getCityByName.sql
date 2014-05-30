IF OBJECT_ID('dbo.wsp_getCityByName') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getCityByName
   IF OBJECT_ID('dbo.wsp_getCityByName') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityByName >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityByName >>>'
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

CREATE PROCEDURE wsp_getCityByName
   @countryId      SMALLINT,
   @jurisdictionId SMALLINT, 
   @cityName       VARCHAR(120)
AS

BEGIN
   SELECT @cityName = LTRIM(RTRIM(UPPER(@cityName)))

   SET ROWCOUNT 1
   SELECT cityId,
          cityName
     FROM City 
    WHERE countryId = @countryId
      AND jurisdictionId = @jurisdictionId
      AND UPPER(cityName) = @cityName 

   RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getCityByName TO web
go

IF OBJECT_ID('dbo.wsp_getCityByName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityByName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityByName >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCityByName','unchained'
go
