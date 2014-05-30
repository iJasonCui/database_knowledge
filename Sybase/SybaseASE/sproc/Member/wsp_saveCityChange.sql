IF OBJECT_ID('dbo.wsp_saveCityChange') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveCityChange
    IF OBJECT_ID('dbo.wsp_saveCityChange') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveCityChange >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveCityChange >>>'
END
go
CREATE PROCEDURE dbo.wsp_saveCityChange
@cityId            INT,
@secondJurisId     SMALLINT,
@jurisId           SMALLINT,
@countryId         SMALLINT,
@cityName          VARCHAR(120),
@population        INT,
@latitudeRad       INT,
@longitudeRad       INT,
@timezoneId         SMALLINT
AS

DECLARE @dateNow   DATETIME,
        @newCityId INT,
        @return    INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
	RETURN @return
END

BEGIN TRAN TRAN_saveCityChange


IF EXISTS (SELECT 1 FROM City WHERE cityId = @cityId)
  BEGIN
    UPDATE City 
    SET  jurisdictionId=@jurisId,
         secondJurisdictionId=@secondJurisId,
         cityName=@cityName,
         cityNameLocal=@cityName,
         latitudeRad=@latitudeRad,
         longitudeRad=@longitudeRad,
         population=@population,
         timezoneId=@timezoneId,
         dateModified=@dateNow
    WHERE cityId = @cityId 

    IF @@error != 0
    BEGIN
	ROLLBACK TRAN TRAN_saveCityChange
	RETURN 97
    END 
    ELSE
    BEGIN
	COMMIT TRAN TRAN_saveCityChange
	RETURN 0
    END
  END
ELSE
  BEGIN

  SELECT @newCityId = MAX(cityId)+1 FROM City
  INSERT City (
      cityId,
      countryId,
      jurisdictionId,
      secondJurisdictionId,
      cityName,
      cityNameLocal,
      latitudeRad,
      longitudeRad,
      timezoneId,
      population,    
      includeInDropdowns,
      ranking,
      dateModified
    )
    VALUES (
      @newCityId,
      @countryId,
      @jurisId,
      @secondJurisId,
      @cityName,
      @cityName,
      @latitudeRad,
      @longitudeRad,
      @timezoneId,
      @population,
      0,
      0,
      @dateNow
    )

    IF @@error != 0
    BEGIN
	ROLLBACK TRAN TRAN_saveCityChange
	RETURN 96
    END 
    ELSE
    BEGIN
	COMMIT TRAN TRAN_saveCityChange
	RETURN 0
   END
END
go
GRANT EXECUTE ON dbo.wsp_saveCityChange TO web
go
IF OBJECT_ID('dbo.wsp_saveCityChange') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveCityChange >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveCityChange >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveCityChange','unchained'
go
GRANT EXECUTE ON dbo.wsp_saveCityChange TO web
go

