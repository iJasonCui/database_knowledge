IF OBJECT_ID('dbo.wsp_getCityById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCityById
    IF OBJECT_ID('dbo.wsp_getCityById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCityById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCityById >>>'
END
go
create proc wsp_getCityById
@id int
as

begin
   set nocount on

   select countryId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName from City
   left join Timezone tz on tz.timezoneId = City.timezoneId and cityId = @id
   where cityId = @id
end
go
GRANT EXECUTE ON dbo.wsp_getCityById TO web
go
IF OBJECT_ID('dbo.wsp_getCityById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCityById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCityById >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCityById','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCityById TO web
go

