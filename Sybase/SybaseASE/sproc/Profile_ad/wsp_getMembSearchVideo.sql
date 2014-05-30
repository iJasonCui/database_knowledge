IF OBJECT_ID('dbo.wsp_getMembSearchVideo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchVideo
    IF OBJECT_ID('dbo.wsp_getMembSearchVideo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchVideo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchVideo >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  Feb 2004
**   Description:  video searches
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: added languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchVideo
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
  IF ( @type = 'P') 
    BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND ProfileMedia.profileFlag='Y'
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
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE
  IF ( @type = 'B') 
    BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND ProfileMedia.backstageFlag='Y'
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
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE
  IF (@type = 'A')
    BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
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
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
 END
 IF (@type = 'N')
    BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
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
         AND ProfileMedia.dateCreated >= dateadd(ss,@startingCutoff,"Jan 1 00:00 1970")
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  IF (@type = 'C')
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
GRANT EXECUTE ON dbo.wsp_getMembSearchVideo TO web
go
IF OBJECT_ID('dbo.wsp_getMembSearchVideo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchVideo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchVideo >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchVideo','unchained'
go
