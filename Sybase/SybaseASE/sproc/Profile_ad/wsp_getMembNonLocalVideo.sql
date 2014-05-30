IF OBJECT_ID('dbo.wsp_getMembNonLocalVideo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembNonLocalVideo
    IF OBJECT_ID('dbo.wsp_getMembNonLocalVideo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembNonLocalVideo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembNonLocalVideo >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Feb 4, 2005
**   Description: non-local video searches
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  July 19, 2006
**   Description: handle null latlong correctly
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembNonLocalVideo
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(2),
@fromLat int,
@fromLong int,
@toLat int,
@toLong int,
@countryId smallint,
@stateId smallint,
@countyId smallint,
@cityId  int,
@languageMask int,
@matchLanguage bit

AS
BEGIN
SET ROWCOUNT @rowcount
IF ( @type = 'P') 
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating 
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@cityId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countyId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@stateId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
          AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
        AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countryId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
ELSE
IF ( @type = 'B') 
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@cityId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countyId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
ELSE
IF ( @type = 'GA') 
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
         AND ProfileMedia.galleryFlag='Y'
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@cityId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
         AND ProfileMedia.galleryFlag='Y'
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countyId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
         AND ProfileMedia.galleryFlag='Y'
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
         AND ProfileMedia.galleryFlag='Y'
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
         AND ProfileMedia.galleryFlag='Y'
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
ELSE
IF (@type = 'A')
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@cityId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countyId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@stateId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE IF (@countryId > -1) 
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
IF (@type = 'N')
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND ProfileMedia.dateCreated >= dateadd(ss,@startingCutoff,"Jan 1 00:00 1970")
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@cityId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1)
  BEGIN
    SELECT
         distinct user_id as userId,
         laston
    FROM ProfileMedia,a_profile_dating
    WHERE
         ProfileMedia.userId *= a_profile_dating.user_id
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
IF (@type = 'C')
BEGIN
  --use square
  IF (@toLat <> 0)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@cityId > -1)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND cityId != @cityId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND secondJurisdictionId != @countyId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND countryId != @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
  BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
  END
END

go
GRANT EXECUTE ON dbo.wsp_getMembNonLocalVideo TO web
go
IF OBJECT_ID('dbo.wsp_getMembNonLocalVideo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembNonLocalVideo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembNonLocalVideo >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembNonLocalVideo','unchained'
go
