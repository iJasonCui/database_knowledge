IF OBJECT_ID('dbo.wsp_getMembSearchLocalGVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchLocalGVIP
    IF OBJECT_ID('dbo.wsp_getMembSearchLocalGVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchLocalGVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchLocalGVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Yadira Genoves X
**   Date:  July 2009
**   Description: Get VIP people
**
****************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchLocalGVIP
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@languageMask int
,@type CHAR(2)
,@fromLat int
,@fromLong int
,@toLat int
,@toLong int
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF (  @toLat <> 0)
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating (INDEX ndx_search_latlong) 
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  
  --use cityId
  ELSE  IF ( @cityId > 0)
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId= @cityId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use countyId
  ELSE  IF ( @countyId > 0)
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId= @countyId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use stateId
  ELSE  IF ( @stateId > 0)
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId= @stateId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use countryId
  ELSE  IF ( @countryId > 0)
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId= @countryId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  
END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchLocalGVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchLocalGVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchLocalGVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchLocalGVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchLocalGVIP TO web
go
