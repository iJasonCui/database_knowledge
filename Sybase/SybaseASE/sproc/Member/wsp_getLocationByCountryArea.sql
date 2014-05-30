IF OBJECT_ID('dbo.wsp_getLocationByCountryArea') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByCountryArea
    IF OBJECT_ID('dbo.wsp_getLocationByCountryArea') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByCountryArea >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByCountryArea >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Jeff Yang/Jack Veiga
**   Date:  September 19 2002
**   Description: Retrieves geographical information by country and city
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getLocationByCountryArea
 @country     VARCHAR(24)
,@countryArea VARCHAR(32)
AS

BEGIN
    SELECT country_id
    ,region_id
    ,country_area_id
    FROM location
    WHERE country_area = @countryArea
    AND country = @country
	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLocationByCountryArea TO web
go
IF OBJECT_ID('dbo.wsp_getLocationByCountryArea') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByCountryArea >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByCountryArea >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByCountryArea','unchained'
go
