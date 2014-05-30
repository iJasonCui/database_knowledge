IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdiction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesOf2ndJurisdiction
    IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdiction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesOf2ndJurisdiction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesOf2ndJurisdiction >>>'
END
go
create proc wsp_getCitiesOf2ndJurisdiction
@jurisdictionId smallint
as

begin
   set nocount on

   select cityId, cityName
   from City, Jurisdiction, Country
   where City.secondJurisdictionId = Jurisdiction.jurisdictionId
   and City.secondJurisdictionId = @jurisdictionId
   and Jurisdiction.jurisdictionId = @jurisdictionId
   and City.countryId = Country.countryId
   and City.population >= Country.minPopulation
   order by cityName

end
go
GRANT EXECUTE ON dbo.wsp_getCitiesOf2ndJurisdiction TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesOf2ndJurisdiction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesOf2ndJurisdiction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesOf2ndJurisdiction >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesOf2ndJurisdiction','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesOf2ndJurisdiction TO web
go

