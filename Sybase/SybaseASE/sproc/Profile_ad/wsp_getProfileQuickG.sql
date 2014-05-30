IF OBJECT_ID('dbo.wsp_getProfileQuickG') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickG
    IF OBJECT_ID('dbo.wsp_getProfileQuickG') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickG >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickG >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 15 2002  
**   Description:  retrieves list of members from quick form (by gender)
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickG
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int
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
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickG TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickG') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickG >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickG >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickG','unchained'
go
