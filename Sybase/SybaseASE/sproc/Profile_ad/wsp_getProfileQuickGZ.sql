IF OBJECT_ID('dbo.wsp_getProfileQuickGZ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGZ
    IF OBJECT_ID('dbo.wsp_getProfileQuickGZ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGZ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGZ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs, Jeff Yang
**   Date:  May 27 2003  
**   Description:  retrieves list of members from quick form by gender,zipcode(lat, long)
**   lastonCutoff.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: change index used
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGZ
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
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
         AND lat_rad >= @fromLat
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGZ TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGZ') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGZ >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGZ >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGZ','unchained'
go
