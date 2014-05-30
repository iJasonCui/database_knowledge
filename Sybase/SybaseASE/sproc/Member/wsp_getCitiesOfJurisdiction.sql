IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdiction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesOfJurisdiction
    IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdiction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesOfJurisdiction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesOfJurisdiction >>>'
END
go
create proc wsp_getCitiesOfJurisdiction
@jurisdictionId smallint
as
begin
   set nocount on
   select cityId, cityName
   from City, Jurisdiction, Country
   where City.jurisdictionId = Jurisdiction.jurisdictionId
   and City.jurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and Jurisdiction.parentId = @jurisdictionId
   and City.secondJurisdictionId = -1
   and City.countryId = Country.countryId
   and City.population >= Country.minPopulation
   order by cityName
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesOfJurisdiction TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesOfJurisdiction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesOfJurisdiction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesOfJurisdiction >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesOfJurisdiction','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesOfJurisdiction TO web
go

