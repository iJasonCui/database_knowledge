IF OBJECT_ID('dbo.wsp_getProfileSearchOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchOnline
    IF OBJECT_ID('dbo.wsp_getProfileSearchOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchOnline >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of new members/pics/backstages since
**   cutoff
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileSearchOnline
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(1)
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF ( @type = 'G') 
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
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
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
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
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND backstage='Y'
         AND backstagetimestamp > @startingCutoff
    UNION
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating ,ProfileMedia
    WHERE a_profile_dating.user_id = ProfileMedia.userId
         AND backstageFlag = 'Y'
         AND on_line='Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
ELSE
  IF (@type = 'V')
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END 
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchOnline TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchOnline') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchOnline >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchOnline >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchOnline','unchained'
go
