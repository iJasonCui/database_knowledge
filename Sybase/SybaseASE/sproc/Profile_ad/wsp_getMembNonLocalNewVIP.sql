IF OBJECT_ID('dbo.wsp_getMembNonLocalNewVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembNonLocalNewVIP
    IF OBJECT_ID('dbo.wsp_getMembNonLocalNewVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembNonLocalNewVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembNonLocalNewVIP >>>'
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
CREATE PROCEDURE wsp_getMembNonLocalNewVIP
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@rowcount int
,@gender char(1)
,@lastonCutoff int
,@startingCutoff int
,@type char(2)
,@fromLat int
,@fromLong int
,@toLat int
,@toLong int
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int
,@languageMask int
AS
BEGIN
SET ROWCOUNT @rowcount
IF ( @type = 'G' OR @type = 'L')
  BEGIN
  IF (@toLat <> 0)
    BEGIN
    SELECT
         user_id,
         laston
    FROM a_profile_dating --(INDEX ndx_search_latlong) 
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
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
         AND (profileFeatures & 2) > 0
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
         AND cityId != @cityId
         AND (profileFeatures & 2) > 0
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
         AND secondJurisdictionId != @countyId
         AND (profileFeatures & 2) > 0
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
         AND jurisdictionId != @stateId
         AND (profileFeatures & 2) > 0
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
         AND countryId != @countryId
         AND (profileFeatures & 2) > 0
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
ELSE IF (@type = 'P')
BEGIN
  IF (@toLat <> 0)
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
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@cityId > -1)
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
         AND cityId != @cityId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1)
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
         AND secondJurisdictionId != @countyId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
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
         AND jurisdictionId != @stateId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1)
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
         AND countryId != @countryId
         AND (profileFeatures & 2) > 0
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
ELSE IF (@type = 'B')
BEGIN
  --use square
  IF (@toLat <> 0)
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use city id
  ELSE IF (@cityId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_backstage)
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
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId != @cityId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  --use secondary jurisdiction id
  ELSE  IF (@countyId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_backstage)
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
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId != @countyId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use jurisdiction id
  ELSE  IF (@stateId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_backstage)
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
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId != @stateId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use country id
  ELSE  IF (@countryId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_backstage)
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
         AND backstagetimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId != @countryId
         AND (profileFeatures & 2) > 0
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
ELSE IF (@type = 'GA')
BEGIN
  --use square
  IF (@toLat <> 0)
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND gallerytimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND (ISNULL(lat_rad,0) < @fromLat 
              OR ISNULL(lat_rad,0) > @toLat
              OR ISNULL(long_rad,0) < @fromLong
              OR ISNULL(long_rad,0) > @toLong)
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use city id
  ELSE IF (@cityId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_gallery)
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
         AND gallerytimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId != @cityId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  --use secondary jurisdiction id
  ELSE  IF (@countyId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_gallery)
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
         AND gallerytimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId != @countyId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use jurisdiction id
  ELSE  IF (@stateId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_gallery)
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
         AND gallerytimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId != @stateId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use country id
  ELSE  IF (@countryId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating --(index ndx_search_gallery)
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
         AND gallerytimestamp > @startingCutoff
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId != @countryId
         AND (profileFeatures & 2) > 0
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
ELSE  -- SR, PR
  BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
  END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembNonLocalNewVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembNonLocalNewVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembNonLocalNewVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembNonLocalNewVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembNonLocalNewVIP TO web
go
