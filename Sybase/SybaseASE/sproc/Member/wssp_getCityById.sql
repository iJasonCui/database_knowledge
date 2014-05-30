IF OBJECT_ID('dbo.wsp_getCityById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getCityById
    IF OBJECT_ID('dbo.wssp_getCityById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getCityById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getCityById >>>'
END
go
create proc wssp_getCityById
@id int
as

begin
   set nocount on

   select countryId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName from City
   left join Timezone tz on tz.timezoneId = City.timezoneId and cityId = @id
   where cityId = @id
end
go
EXEC sp_procxmode 'dbo.wssp_getCityById','unchained'
go
IF OBJECT_ID('dbo.wssp_getCityById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getCityById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getCityById >>>'
go
GRANT EXECUTE ON dbo.wssp_getCityById TO web
go
