IF OBJECT_ID('dbo.wsp_getLocationByLatLong') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocationByLatLong
    IF OBJECT_ID('dbo.wsp_getLocationByLatLong') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocationByLatLong >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocationByLatLong >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author: Jack Veiga
**   Date:  June 4 2002
**   Description: Retrieves geographical information by latitude and longtitude
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getLocationByLatLong
 @lat_rad   INT
,@long_rad  INT
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
    AND m.country_area = l.country_area
    AND m.country_area = l.country_area
    AND @lat_rad  <= lat_rad_tl
    AND @lat_rad >= lat_rad_br
    AND @long_rad <= long_rad_tl
    AND @long_rad >= long_rad_br

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getLocationByLatLong TO web
go
IF OBJECT_ID('dbo.wsp_getLocationByLatLong') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocationByLatLong >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocationByLatLong >>>'
go
EXEC sp_procxmode 'dbo.wsp_getLocationByLatLong','unchained'
go
