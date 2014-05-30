IF OBJECT_ID('dbo.wsp_getProfileQuickGW') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGW
    IF OBJECT_ID('dbo.wsp_getProfileQuickGW') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGW >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGW >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 15 2002  
**   Description:  retrieves list of members from quick form (by gender, picture, and age)
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGW
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@fromAge datetime,
@toAge  datetime
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
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGW TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGW') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGW >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGW >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGW','unchained'
go
