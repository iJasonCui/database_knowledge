IF OBJECT_ID('dbo.wsp_getLatLongByCityLava') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByCityLava
    IF OBJECT_ID('dbo.wsp_getLatLongByCityLava') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByCityLava >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByCityLava >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author: Generator 
**   Date: @TIMESTAMP@ 
**   Description: getLatLongByCityLava 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLatLongByCityLava
    @cityId int
AS

BEGIN

   BEGIN TRAN TRAN_getLatLongByCityLava


   
   DECLARE @lat int, @lon int   
   SELECT @lat=latitudeRad, @lon=longitudeRad
   FROM City
   WHERE cityId = @cityId 

   IF @lat IS NOT NULL

   BEGIN

   SELECT @lat=@lat + 157079 
   SELECT @lon=@lon * (-1)
   SELECT @lat as latitude, @lon as longitude 
   END

    


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLatLongByCityLava
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLatLongByCityLava
   END

END

go
IF OBJECT_ID('dbo.wsp_getLatLongByCityLava') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByCityLava >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByCityLava >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLatLongByCityLava','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLatLongByCityLava TO web
go
