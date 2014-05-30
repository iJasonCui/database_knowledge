IF OBJECT_ID('dbo.wsp_getCitiesByCountryId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCitiesByCountryId
    IF OBJECT_ID('dbo.wsp_getCitiesByCountryId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCitiesByCountryId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCitiesByCountryId >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Travis McCauley
**   Date: May 2004
**   Description: Selects all qualifying cities for the countryId supplied
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
create proc wsp_getCitiesByCountryId
@countryId int
as

begin
   set nocount on
   
BEGIN TRAN TRN_getCitiesByCountryId

   select City.cityId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName, loc_m
   from City
   left join Timezone tz on tz.timezoneId = City.timezoneId and City.countryId = @countryId
   inner join Country on City.countryId = Country.countryId 
      and City.countryId = @countryId
      and Country.countryId = @countryId
   and City.population >= Country.minPopulation

if @@error =0
   COMMIT TRAN TRN_getCitiesByCountryId
else 
   ROLLBACK TRAN TRN_getCitiesByCountryId
   
end
go
GRANT EXECUTE ON dbo.wsp_getCitiesByCountryId TO web
go
IF OBJECT_ID('dbo.wsp_getCitiesByCountryId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCitiesByCountryId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCitiesByCountryId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCitiesByCountryId','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCitiesByCountryId TO web
go

