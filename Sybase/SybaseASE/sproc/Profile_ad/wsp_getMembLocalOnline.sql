IF OBJECT_ID('dbo.wsp_getMembLocalOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembLocalOnline
    IF OBJECT_ID('dbo.wsp_getMembLocalOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembLocalOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembLocalOnline >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Feb 4, 2005
**   Description: localized online searches
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  Sept 29, 2006
**   Description: sort priv lists (hot, smile, pass, block) by dateCreated DESC instead of laston
**                and ignore location
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembLocalOnline
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
IF ( @type = 'G' OR @type='L') 
BEGIN
  IF (@toLat <> 0)
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
IF (@type = 'P')
BEGIN
  IF (@toLat <> 0)
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
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
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND on_line='Y'
         AND pict='Y'
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
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
IF (@type = 'B') 
BEGIN
  --use square
  IF (@toLat <> 0)
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating (index ndx_search_backstage)
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use city id
  ELSE IF (@cityId > -1) 
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId = @cityId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId = @cityId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  --use secondary jurisdiction id
  ELSE  IF (@countyId > -1) 
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId = @countyId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId = @countyId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use jurisdiction id
  ELSE  IF (@stateId > -1) 
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId = @stateId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId = @stateId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use country id
  ELSE  IF (@countryId > -1) 
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId = @countryId
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
IF (@type = 'H')  -- ignore location now
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,"Jan 1 00:00:00 1970",Hotlist.dateCreated)
    FROM Hotlist,a_profile_dating
    WHERE
         Hotlist.targetUserId = a_profile_dating.user_id
         AND Hotlist.userId = @userId
         AND on_line='Y'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND laston > @startingCutoff
         AND  Hotlist.dateCreated < dateadd(ss,@lastonCutoff,"Jan 1 00:00:00 1970")             
    ORDER BY Hotlist.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SR') 
BEGIN
    SELECT 
         userId,
         datediff(ss,"Jan 1 00:00:00 1970",Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.userId = a_profile_dating.user_id
         AND Smile.targetUserId = @userId
         AND on_line='Y'
         AND seen != 'T'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND laston > @startingCutoff
         AND  Smile.dateCreated < dateadd(ss,@lastonCutoff,"Jan 1 00:00:00 1970")             
    ORDER BY Smile.dateCreated DESC, userId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
ELSE
IF (@type = 'SS') 
BEGIN
    SELECT 
         targetUserId,
         datediff(ss,"Jan 1 00:00:00 1970",Smile.dateCreated)
    FROM Smile,a_profile_dating
    WHERE
         Smile.targetUserId=a_profile_dating.user_id
         AND Smile.userId = @userId
         AND on_line='Y'
         AND show_prefs BETWEEN 'A' AND 'Z'
         AND laston > @startingCutoff
         AND  Smile.dateCreated < dateadd(ss,@lastonCutoff,"Jan 1 00:00:00 1970")             
    ORDER BY Smile.dateCreated DESC, targetUserId 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END
ELSE  -- should never get here!!!!
  BEGIN
      SELECT 0 WHERE 0=1
      RETURN @@error
  END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembLocalOnline','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembLocalOnline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembLocalOnline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembLocalOnline >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembLocalOnline TO web
go
