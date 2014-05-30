IF OBJECT_ID('dbo.wsp_getLocationByZip') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByZip
    IF OBJECT_ID('dbo.wsp_getLocationByZip') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByZip >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByZip >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Description: getLocationByZip 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getLocationByZip
    @postalCode varchar(10)
AS

BEGIN

   BEGIN TRAN TRAN_getLocationByZip

   SELECT countryId, jurisdictionId, secondJurisdictionId, cityId 
   FROM PostalZipCode 
   WHERE zipcode=@postalCode

   IF @@error = 0
   BEGIN
      COMMIT TRAN TRAN_getLocationByZip
   END
   ELSE BEGIN
      ROLLBACK TRAN TRAN_getLocationByZip
   END

END

go
IF OBJECT_ID('dbo.wsp_getLocationByZip') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByZip >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByZip >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByZip','unchained'
go
GRANT EXECUTE ON dbo.wsp_getLocationByZip TO web
go
