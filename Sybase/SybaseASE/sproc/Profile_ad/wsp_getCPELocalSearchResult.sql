IF OBJECT_ID('dbo.wsp_getCPELocalSearchResult') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCPELocalSearchResult
    IF OBJECT_ID('dbo.wsp_getCPELocalSearchResult') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCPELocalSearchResult >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCPELocalSearchResult >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  December 14, 2005
**   Description: CPEEP local search, used for CRM email, if lat/long <> 0 return result based
**   on lat/long, else if cityId > 0 use that, etc.
**
******************************************************************************/
CREATE PROCEDURE  wsp_getCPELocalSearchResult
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@startingCutoff int,
@fromLat int,
@toLat int,
@fromLong int,
@toLong int,
@cityId  int,
@countyId smallint,
@stateId smallint,
@countryId smallint,
@languageMask int,
@startBirthdate datetime,
@endBirthdate datetime

AS
BEGIN
SET ROWCOUNT @rowcount
  IF (@cityId > 0)
  BEGIN
    SELECT 
      p.user_id,
      myidentity,
      p.birthdate,
      p.countryId,
      p.jurisdictionId,
      p.secondJurisdictionId,
      p.cityId,
      created_on
    FROM a_profile_dating p (INDEX ndx_search_pict)
    WHERE
         show='Y' 
         AND show_prefs='Y' 
         AND approved='Y'
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=p.user_id
         )
         AND ISNULL(mediaReleaseFlag,'Y') != 'N'
         AND p.laston > @startingCutoff
         AND p.gender = @gender
         AND pict='Y'
         AND p.birthdate  >= @startBirthdate
         AND p.birthdate <= @endBirthdate
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND p.cityId = @cityId
    ORDER BY p.laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@toLat <> 0)
  BEGIN
    SELECT 
      user_id,
      myidentity,
      birthdate,
      countryId,
      jurisdictionId,
      secondJurisdictionId,
      cityId,
      created_on
    FROM a_profile_dating p (INDEX ndx_search_pict)
    WHERE
         show='Y' 
         AND show_prefs='Y' 
         AND approved='Y'
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=p.user_id
         )
         AND ISNULL(mediaReleaseFlag,'Y') != 'N'
         AND p.laston > @startingCutoff
         AND p.gender = @gender
         AND pict='Y'
         AND p.birthdate  >= @startBirthdate
         AND p.birthdate <= @endBirthdate
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND p.lat_rad >= @fromLat 
         AND p.lat_rad <= @toLat
         AND p.long_rad >= @fromLong
         AND p.long_rad <= @toLong
    ORDER BY p.laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > 0)
  BEGIN
    SELECT 
      p.user_id,
      myidentity,
      p.birthdate,
      p.countryId,
      p.jurisdictionId,
      p.secondJurisdictionId,
      p.cityId,
      created_on
    FROM a_profile_dating p (INDEX ndx_search_pict)
    WHERE
         show='Y' 
         AND show_prefs='Y' 
         AND approved='Y'
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=p.user_id
         )
         AND ISNULL(mediaReleaseFlag,'Y') != 'N'
         AND p.laston > @startingCutoff
         AND p.gender = @gender
         AND pict='Y'
         AND p.birthdate  >= @startBirthdate
         AND p.birthdate <= @endBirthdate
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND p.jurisdictionId = @stateId
    ORDER BY p.laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > 0)
  BEGIN
    SELECT 
      p.user_id,
      myidentity,
      p.birthdate,
      p.countryId,
      p.jurisdictionId,
      p.secondJurisdictionId,
      p.cityId,
      created_on
    FROM a_profile_dating p (INDEX ndx_search_pict)
    WHERE
         show='Y' 
         AND show_prefs='Y' 
         AND approved='Y'
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=p.user_id
         )
         AND ISNULL(mediaReleaseFlag,'Y') != 'N'
         AND p.laston > @startingCutoff
         AND p.gender = @gender
         AND pict='Y'
         AND p.birthdate  >= @startBirthdate
         AND p.birthdate <= @endBirthdate
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND p.countryId = @countryId
    ORDER BY p.laston desc, user_id 
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
GRANT EXECUTE ON dbo.wsp_getCPELocalSearchResult TO web
go
IF OBJECT_ID('dbo.wsp_getCPELocalSearchResult') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCPELocalSearchResult >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCPELocalSearchResult >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCPELocalSearchResult','unchained'
go
