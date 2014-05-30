IF OBJECT_ID('dbo.wsp_getMembSearchNewVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchNewVIP
    IF OBJECT_ID('dbo.wsp_getMembSearchNewVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchNewVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchNewVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Yadira Genoves X
**   Date:  July 2009
**   Description: Get VIP people
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchNewVIP
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
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND created_on > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND (profileFeatures & 2) > 0
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
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp >=@startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND pict = 'Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND (profileFeatures & 2) > 0
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
    FROM a_profile_dating --(index ndx_search)
    WHERE
         (backstage = 'Y' OR user_id in (select userId from ProfileMedia where backstageFlag = 'Y') )
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
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'GA')
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search)
    WHERE
         (gallery = 'Y' OR user_id in (select userId from ProfileMedia where galleryFlag = 'Y') )
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
         AND (profileFeatures & 2) > 0
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
         AND seen != 'T'
         AND dateCreated > dateadd(ss,@startingCutoff,'Dec 31 20:00 1969')
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'PR')
    BEGIN
    SELECT
         user_id,
         laston
    FROM a_profile_dating,Pass
    WHERE
         a_profile_dating.user_id=Pass.userId
         AND Pass.targetUserId = @userId
         AND dateCreated > dateadd(ss,@startingCutoff,'Dec 31 20:00 1969')
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND seen != 'T'
         AND ISNULL(messageOnHoldStatus,'A') != 'H'
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND (a_profile_dating.profileFeatures & 2) > 0
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
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND ProfileMedia.dateCreated >= dateadd(ss,@startingCutoff,'Jan 1 00:00 1970')
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchNewVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchNewVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchNewVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchNewVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchNewVIP TO web
go
