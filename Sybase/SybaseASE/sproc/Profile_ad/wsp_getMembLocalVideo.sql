IF OBJECT_ID('dbo.wsp_getMembLocalVideo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembLocalVideo
    IF OBJECT_ID('dbo.wsp_getMembLocalVideo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembLocalVideo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembLocalVideo >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Feb 4, 2005
**   Description: localized video searches
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembLocalVideo
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND cityId = @cityId
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
         AND secondJurisdictionId = @countyId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND cityId = @cityId
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
         AND secondJurisdictionId = @countyId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND cityId = @cityId
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
         AND secondJurisdictionId = @countyId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId = @cityId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId = @countyId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId = @stateId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId = @countryId
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
         AND ProfileMedia.dateCreated >= dateadd(ss,@startingCutoff,"Jan 1 00:00 1970")
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND ProfileMedia.mediaType = 'v'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND cityId = @cityId
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
         AND secondJurisdictionId = @countyId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
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
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId = @cityId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId = @countyId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId = @stateId
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND on_line='Y'
         AND gender = @gender
         AND video IN ('Y', 'D', 'H')
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId = @countryId
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
GRANT EXECUTE ON dbo.wsp_getMembLocalVideo TO web
go
IF OBJECT_ID('dbo.wsp_getMembLocalVideo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembLocalVideo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembLocalVideo >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembLocalVideo','unchained'
go
