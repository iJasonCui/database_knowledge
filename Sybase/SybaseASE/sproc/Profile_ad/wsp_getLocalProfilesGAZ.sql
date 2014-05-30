IF OBJECT_ID('dbo.wsp_getLocalProfilesGAZ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLocalProfilesGAZ
    IF OBJECT_ID('dbo.wsp_getLocalProfilesGAZ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLocalProfilesGAZ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLocalProfilesGAZ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Francisc Schonberger
**   Date:  Oct 2004
**   Description:  get members from quick form by gender, age , and zip(lat,long)
**   lastonCutoff.
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getLocalProfilesGAZ
@productCode char(1),
@communityCode char(1),
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@fromAge datetime,
@toAge  datetime,
@fromLat int,
@fromLong int,
@toLat int,
@toLong int

AS
BEGIN
    SELECT user_id as id, laston, lat_rad, long_rad 
    FROM a_profile_dating (INDEX XIE_search_latlong)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND lat_rad >= @fromLat
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
go
GRANT EXECUTE ON dbo.wsp_getLocalProfilesGAZ TO web
go
IF OBJECT_ID('dbo.wsp_getLocalProfilesGAZ') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getLocalProfilesGAZ >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLocalProfilesGAZ >>>'
go
