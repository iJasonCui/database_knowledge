IF OBJECT_ID('dbo.wsp_getMemberLocProfilesGAZB') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMemberLocProfilesGAZB
    IF OBJECT_ID('dbo.wsp_getMemberLocProfilesGAZB') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMemberLocProfilesGAZB >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMemberLocProfilesGAZB >>>'
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
CREATE PROCEDURE wsp_getMemberLocProfilesGAZB
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
@toLong int,
@userId NUMERIC(12,0)

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
	   AND backstage='Y'
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
    UNION
    SELECT user_id as id, laston, lat_rad, long_rad
    FROM ProfileMedia, a_profile_dating (INDEX XIE_search_latlong)
    WHERE
	   ProfileMedia.userId  = a_profile_dating.user_id
 	   AND backstageFlag = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
 AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND lat_rad >= @fromLat
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
go
IF OBJECT_ID('dbo.wsp_getMemberLocProfilesGAZB') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMemberLocProfilesGAZB >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMemberLocProfilesGAZB >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMemberLocProfilesGAZB','unchained'
go
GRANT EXECUTE ON dbo.wsp_getMemberLocProfilesGAZB TO web
go
