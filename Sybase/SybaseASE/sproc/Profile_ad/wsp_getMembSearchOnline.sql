IF OBJECT_ID('dbo.wsp_getMembSearchOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchOnline
    IF OBJECT_ID('dbo.wsp_getMembSearchOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchOnline >>>'
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
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: added languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchOnline
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@languageMask int,
@type char(2)
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF ( @type = 'G') 
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'P')
    BEGIN
    SELECT
      user_id,
      laston     
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'B') 
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(index ndx_search_backstage)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND backstage='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    UNION
    SELECT
        -- distinct 
         user_id as userId,
         laston
    FROM ProfileMedia,  a_profile_dating 
    WHERE ProfileMedia.userId =  a_profile_dating.user_id 
         AND backstageFlag = 'Y'
         AND on_line='Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
  ELSE
  IF (@type = 'H') 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Hotlist
    WHERE
         a_profile_dating.user_id=Hotlist.targetUserId
         AND Hotlist.userId = @userId
         AND on_line='Y'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SR') 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.userId
         AND Smile.targetUserId = @userId
         AND on_line='Y'
         AND seen != 'T'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'SS') 
    BEGIN
    SELECT 
         user_id,
         laston
    FROM a_profile_dating,Smile
    WHERE
         a_profile_dating.user_id=Smile.targetUserId
         AND Smile.userId = @userId
         AND seen != 'F'
         AND on_line='Y'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
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
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND video IN ('Y', 'D', 'H')
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembSearchOnline TO web
go
IF OBJECT_ID('dbo.wsp_getMembSearchOnline') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchOnline >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchOnline >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchOnline','unchained'
go
