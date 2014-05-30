IF OBJECT_ID('dbo.wsp_getProfileSearchBrowse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchBrowse
    IF OBJECT_ID('dbo.wsp_getProfileSearchBrowse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchBrowse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchBrowse >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of members/pics/backstages since
**   lastonCutoff
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileSearchBrowse
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
  ELSE
  IF (@type = 'P')
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating (INDEX ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
          AND gender = @gender
         AND pict='Y'
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'B') 
   BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating (index ndx_search_backstage) 
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND backstage='Y'
	 AND backstagetimestamp > @startingCutoff
    UNION
    SELECT
	user_id as id,
         laston
    FROM ProfileMedia,  a_profile_dating 
    WHERE ProfileMedia.userId =  a_profile_dating.user_id 
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
         distinct user_id as id,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
END 
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchBrowse TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchBrowse') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchBrowse >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchBrowse >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchBrowse','unchained'
go
