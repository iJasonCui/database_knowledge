IF OBJECT_ID('dbo.wsp_getLatLongFixByZip') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLatLongFixByZip
    IF OBJECT_ID('dbo.wsp_getLatLongFixByZip') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLatLongFixByZip >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLatLongFixByZip >>>'
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
CREATE PROCEDURE  wsp_getLatLongFixByZip
    @postalCode varchar(10)
AS

BEGIN

   BEGIN TRAN TRAN_getLatLongFixByZip


   
   DECLARE @lat int, @lon int, @countryId int   
   SELECT @lat=lat_rad, @lon=long_rad, @countryId = countryId
   FROM PostalZipCode
   WHERE zipcode = @postalCode 

   IF @lat IS NOT NULL

   BEGIN
-- this is to fix the inconsistent data in zipcode table

   IF (@countryId = 244 OR @countryId = 40) 

   BEGIN
   
   SELECT @lat=@lat-157079    
   SELECT @lon=@lon* (-1)
   END

 ELSE     

   IF (@countryId = 13 OR @countryId = 242)    

   BEGIN
      
   SELECT @lat=@lat-2   
   END

  
   SELECT @lat as latitude, @lon as longitude
   END

    


   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLatLongFixByZip
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLatLongFixByZip
   END

END
go

GRANT EXECUTE ON dbo.wsp_getLatLongFixByZip TO web
go

IF OBJECT_ID('dbo.wsp_getLatLongFixByZip') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLatLongFixByZip >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLatLongFixByZip >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLatLongFixByZip','unchained'
go

