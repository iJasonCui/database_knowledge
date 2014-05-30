IF OBJECT_ID('dbo.wsp_populate_CityNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_populate_CityNew
    IF OBJECT_ID('dbo.wsp_populate_CityNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_populate_CityNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_populate_CityNew >>>'
END
go

CREATE PROCEDURE wsp_populate_CityNew
AS
BEGIN

   DECLARE @cityId INT
   DECLARE @latitudeRad  INT
   DECLARE @longitudeRad INT


   DECLARE @cnt NUMERIC(10, 0)

   DECLARE @dateNow DATETIME 
   EXEC wsp_GetDateGMT @dateNow OUTPUT

   
   DECLARE CUR_CityNew CURSOR FOR
   SELECT cityId,latitudeRad,longitudeRad
   FROM tempdb..CityNew_a FOR READ ONLY
   
   OPEN CUR_CityNew
   FETCH CUR_CityNew INTO @cityId,@latitudeRad,@longitudeRad
   
   Select @cnt = 0 
   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
      BEGIN
         CLOSE CUR_CityNew
         DEALLOCATE CURSOR CUR_CityNew
         RETURN 99
      END


      INSERT INTO CityNew
      VALUES(@cityId,@latitudeRad,@longitudeRad)
      
      Select @cnt = @cnt + 1

   
      FETCH CUR_CityNew INTO  @cityId,@latitudeRad,@longitudeRad
   END
   Select "Number ofrecords " + convert(varchar, @cnt) 
   CLOSE CUR_CityNew
   DEALLOCATE CURSOR CUR_CityNew
 
   
END





go
EXEC sp_procxmode 'dbo.wsp_populate_CityNew','unchained'
go
IF OBJECT_ID('dbo.wsp_populate_CityNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_populate_CityNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_populate_CityNew >>>'
go

