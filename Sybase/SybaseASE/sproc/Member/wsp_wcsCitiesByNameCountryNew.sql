IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountryNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsCitiesByNameCountryNew
    IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountryNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsCitiesByNameCountryNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsCitiesByNameCountryNew >>>'
END
go
CREATE PROCEDURE wsp_wcsCitiesByNameCountryNew
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
   FROM City_new c
   LEFT JOIN Country ON Country.countryId = c.countryId
   LEFT JOIN Jurisdiction j ON j.jurisdictionId = c.jurisdictionId
   LEFT JOIN Jurisdiction sj ON sj.jurisdictionId = c.secondJurisdictionId
   WHERE c.countryId = @countryId
   AND cityName like @cityName
   ORDER BY cityName
END
go
GRANT EXECUTE ON dbo.wsp_wcsCitiesByNameCountryNew TO web
go
IF OBJECT_ID('dbo.wsp_wcsCitiesByNameCountryNew') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsCitiesByNameCountryNew >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsCitiesByNameCountryNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsCitiesByNameCountryNew','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsCitiesByNameCountryNew TO web
go

