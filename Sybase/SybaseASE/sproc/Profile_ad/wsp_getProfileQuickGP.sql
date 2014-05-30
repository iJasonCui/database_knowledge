IF OBJECT_ID('dbo.wsp_getProfileQuickGP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGP
    IF OBJECT_ID('dbo.wsp_getProfileQuickGP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGP >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 15 2002  
**   Description:  retrieves list of members from quick form (by gender and picture)
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGP
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1)
AS
BEGIN
  SET ROWCOUNT @rowcount
  SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating (INDEX ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND pict=@pictureFlag
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGP TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGP') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGP >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGP >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGP','unchained'
go
