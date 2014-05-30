IF OBJECT_ID('dbo.wsp_getProfileQuickGPAZ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGPAZ
    IF OBJECT_ID('dbo.wsp_getProfileQuickGPAZ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGPAZ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGPAZ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs, Jeff Yang, Yahya Kola.
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
CREATE PROCEDURE wsp_getProfileQuickGPAZ
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@pictureFlag CHAR(1)
,@fromAge DATETIME
,@toAge  DATETIME
,@fromLat INT
,@fromLong INT
,@toLat INT
,@toLong INT

AS
BEGIN
  SET ROWCOUNT @rowcount
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
	 AND pict=@pictureFlag
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
IF OBJECT_ID('dbo.wsp_getProfileQuickGPAZ') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGPAZ >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGPAZ >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGPAZ','unchained'
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGPAZ TO web
go
