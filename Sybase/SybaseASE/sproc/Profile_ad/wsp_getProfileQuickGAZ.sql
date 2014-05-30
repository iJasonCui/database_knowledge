IF OBJECT_ID('dbo.wsp_getProfileQuickGAZ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGAZ
    IF OBJECT_ID('dbo.wsp_getProfileQuickGAZ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGAZ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGAZ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs, Jeff Yang
**   Date:  June 2003
**   Description:  retrieves list of members from quick form by gender, age , and zip(lat,long)
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: change index used
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGAZ
@productCode char(1),
@communityCode char(1),
@rowcount int,
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
  SET ROWCOUNT @rowcount
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating (INDEX ndx_search)
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
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGAZ TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGAZ') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGAZ >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGAZ >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGAZ','unchained'
go
