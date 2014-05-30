IF OBJECT_ID('dbo.wsp_getCountries') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCountries
    IF OBJECT_ID('dbo.wsp_getCountries') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCountries >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCountries >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Travis McCauley 
**   Date:  April 2004  
**   Description:  get list of countries from City DB 
**
** REVISION(S):
**   Author: Travis McCauley
**   Date: June 14, 2004
**   Description: worked around bug in join that caused the country Georgia to appear twice
**
******************************************************************************/

create proc wsp_getCountries as

begin
   set nocount on

   select Country.countryId, countryCodeIso, countryLabel, legacyLocation, regionLabel, jt1.jurisdictionTypeLabel, jt2.jurisdictionTypeLabel, loc_c, register from Country
   left join LegacyLocationMap  on newLocation=countryLabel and legacyLocation != 'Georgia/USA'

   left join CountryJurisdictionType cjt1  on Country.countryId = cjt1.countryId and cjt1.jurisdictionLevel=1
   left join CountryJurisdictionType cjt2  on Country.countryId = cjt2.countryId and cjt2.jurisdictionLevel=2

   left join JurisdictionType jt1 on cjt1.jurisdictionTypeId = jt1.jurisdictionTypeId
   left join JurisdictionType jt2 on cjt2.jurisdictionTypeId = jt2.jurisdictionTypeId

   -- exclude non ISO countries
    where Country.countryId not in (14, 32, 34, 64, 74, 83, 92, 95, 102, 112, 115, 122, 126, 127, 143, 161, 183, 187, 225, 240, 255,
 54, 107, 131, 188, 258)

    -- exclude countries with no cities in the db
    and Country.countryId not in ( 17, 37, 114, 105, 124, 253 )
   order by countryLabel
end
go
GRANT EXECUTE ON dbo.wsp_getCountries TO web
go
IF OBJECT_ID('dbo.wsp_getCountries') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getCountries >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCountries >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCountries','unchained'
go
GRANT EXECUTE ON dbo.wsp_getCountries TO web
go

