IF OBJECT_ID('dbo.wsp_getLocationByCountryCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByCountryCity
    IF OBJECT_ID('dbo.wsp_getLocationByCountryCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByCountryCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByCountryCity >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author: Jack Veiga
**   Date:  June 4 2002
**   Description: Retrieves geographical information by country and city
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getLocationByCountryCity
 @country       VARCHAR(24)
,@countryArea   VARCHAR(32)
,@city          VARCHAR(24)
AS

BEGIN
    SELECT l.country
    ,country_id
    ,region_id
    ,l.country_area
    ,country_area_id
    ,metrocode
    FROM metro m, location l
    WHERE web='Y'
    AND m.country_area = @countryArea
    AND m.country_area = l.country_area
    AND m.country = @country
    AND m.city = @city

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLocationByCountryCity TO web
go
IF OBJECT_ID('dbo.wsp_getLocationByCountryCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByCountryCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByCountryCity >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByCountryCity','unchained'
go
