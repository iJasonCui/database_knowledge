IF OBJECT_ID('dbo.wsp_getProfileSearchNew') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchNew
    IF OBJECT_ID('dbo.wsp_getProfileSearchNew') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchNew >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchNew >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 13 2002  
**   Description:  retrieves list of new members/pics/backstages since
**   cutoff
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileSearchNew
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(2)
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF ( @type = 'G') 
    BEGIN
    SELECT 
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND created_on > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'P')
    BEGIN
    SELECT 
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND pictimestamp >=@startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff 
         AND pict = 'Y'
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'B') 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_backstage)
    WHERE
         backstage = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
    UNION
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating, ProfileMedia
    WHERE a_profile_dating.user_id = ProfileMedia.userId
         AND backstageFlag = 'Y'
         AND dateCreated > dateadd(ss,@startingCutoff,"Jan 1 1970")
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'VP')
    BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND ProfileMedia.dateCreated >= dateadd(ss,@startingCutoff,"Jan 1 1970")
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchNew TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchNew') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchNew >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchNew >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchNew','unchained'
go
