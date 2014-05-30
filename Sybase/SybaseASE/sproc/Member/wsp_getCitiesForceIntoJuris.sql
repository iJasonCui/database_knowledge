IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJuris') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesForceIntoJuris
    IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJuris') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesForceIntoJuris >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesForceIntoJuris >>>'
END
go
create proc wsp_getCitiesForceIntoJuris
@jurisdictionId smallint
as
begin
   set nocount on
   select cityId, cityName
   from City, Jurisdiction, Country
   where City.jurisdictionId = Jurisdiction.jurisdictionId
   and City.jurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and City.countryId = Country.countryId
   and City.population >= Country.minPopulation
   order by cityName
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesForceIntoJuris TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesForceIntoJuris') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesForceIntoJuris >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesForceIntoJuris >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesForceIntoJuris','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesForceIntoJuris TO web
go

