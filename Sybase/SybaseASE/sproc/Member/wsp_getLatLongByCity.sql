IF OBJECT_ID('dbo.wsp_getLatLongByCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongByCity
    IF OBJECT_ID('dbo.wsp_getLatLongByCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongByCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongByCity >>>'
END
go 

/***********************************************************************
**
** CREATION:
**   Author: Generator 
**   Date: @TIMESTAMP@ 
**   Description: getLatLongByCity 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLatLongByCity
    @cityId int
AS

BEGIN

   BEGIN TRAN TRAN_getLatLongByCity


   
   DECLARE @lat int, @lon int   
   SELECT @lat=latitudeRad, @lon=longitudeRad
   FROM City
   WHERE cityId = @cityId 

   IF @lat IS NOT NULL

   BEGIN

   SELECT @lat=@lat-2 
   SELECT @lat as latitude, @lon as longitude 
   END

    


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLatLongByCity
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLatLongByCity
   END

END
go

GRANT EXECUTE ON dbo.wsp_getLatLongByCity TO web
go

IF OBJECT_ID('dbo.wsp_getLatLongByCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongByCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongByCity >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLatLongByCity','unchained'
go

