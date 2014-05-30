IF OBJECT_ID('dbo.wsp_getCPENonLocalSearchResult') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCPENonLocalSearchResult
    IF OBJECT_ID('dbo.wsp_getCPENonLocalSearchResult') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCPENonLocalSearchResult >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCPENonLocalSearchResult >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  December 14, 2005
**   Description: CPEEP non-local search, used for CRM email,  not same country
**
******************************************************************************/
CREATE PROCEDURE  wsp_getCPENonLocalSearchResult
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
         AND p.countryId != @countryId
    ORDER BY p.laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getCPENonLocalSearchResult TO web
go
IF OBJECT_ID('dbo.wsp_getCPENonLocalSearchResult') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCPENonLocalSearchResult >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCPENonLocalSearchResult >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCPENonLocalSearchResult','unchained'
go
