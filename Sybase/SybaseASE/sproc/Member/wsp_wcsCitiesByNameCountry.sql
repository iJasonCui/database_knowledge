IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountry') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsCitiesByNameCountry
    IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountry') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsCitiesByNameCountry >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsCitiesByNameCountry >>>'
END
go
CREATE PROCEDURE wsp_wcsCitiesByNameCountry
@countryId SMALLINT
,@cityName VARCHAR(120)
AS
BEGIN
   SET ROWCOUNT 100
   SELECT cityId, 
          cityName,
          c.countryId, 
          c.jurisdictionId,
          c.secondJurisdictionId, 
          latitudeRad, 
          longitudeRad,
          population,
          countryLabel,
          c.timezoneId,
          j.jurisdictionName, 
          sj.jurisdictionName as secondaryJurisName 
   FROM City c
   LEFT JOIN Country ON Country.countryId = c.countryId
   LEFT JOIN Jurisdiction j ON j.jurisdictionId = c.jurisdictionId
   LEFT JOIN Jurisdiction sj ON sj.jurisdictionId = c.secondJurisdictionId
   WHERE c.countryId = @countryId
   AND cityName like @cityName
   ORDER BY cityName
END
go
GRANT EXECUTE ON dbo.wsp_wcsCitiesByNameCountry TO web
go
IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountry') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsCitiesByNameCountry >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsCitiesByNameCountry >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsCitiesByNameCountry','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsCitiesByNameCountry TO web
go

