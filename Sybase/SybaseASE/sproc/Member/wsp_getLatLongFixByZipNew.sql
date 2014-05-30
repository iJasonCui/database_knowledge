IF OBJECT_ID('dbo.wsp_getLatLongFixByZipNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongFixByZipNew
    IF OBJECT_ID('dbo.wsp_getLatLongFixByZipNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongFixByZipNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongFixByZipNew >>>'
END
go 

/***********************************************************************
**
** CREATION:
**   Author: Generator 
**   Date: @TIMESTAMP@ 
**   Description: getLatLongFixByZip 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLatLongFixByZipNew
    @postalCode varchar(10)
AS

BEGIN

   BEGIN TRAN TRAN_getLatLongFixByZipNew


   
   DECLARE @lat int, @lon int, @countryId int   
   SELECT lat_rad as latitude, long_rad as longitude, countryId
   FROM PostalZipCode_New
   WHERE zipcode = @postalCode 

   --IF @lat IS NOT NULL

   --BEGIN
-- this is to fix the inconsistent data in zipcode table

   --IF (@countryId = 244 OR @countryId = 40) 

   --BEGIN
   
   --SELECT @lat=@lat-157079    
   --SELECT @lon=@lon* (-1)
   --END

 --ELSE     

   --IF (@countryId = 13 OR @countryId = 242)    

   --BEGIN
      
   --SELECT @lat=@lat-2   
   --END

  
   --SELECT @lat as latitude, @lon as longitude
   --END

    


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLatLongFixByZipNew
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLatLongFixByZipNew
   END

END
go

GRANT EXECUTE ON dbo.wsp_getLatLongFixByZipNew TO web
go

IF OBJECT_ID('dbo.wsp_getLatLongFixByZipNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongFixByZipNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongFixByZipNew >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLatLongFixByZipNew','unchained'
go

