IF OBJECT_ID('dbo.wsp_getMembNonLocalVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembNonLocalVIP
    IF OBJECT_ID('dbo.wsp_getMembNonLocalVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembNonLocalVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembNonLocalVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  June 2010
**   Description: Get Featured member by gender, age, language mask for NONE local
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembNonLocalVIP
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
,@startBirthdate DATETIME
,@endBirthdate DATETIME
AS

BEGIN
  SET ROWCOUNT @rowcount
  IF @toLat <> 0
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(index ndx_search_latlong)
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
         --AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
       AND (ISNULL(lat_rad,0) < @fromLat 
      OR ISNULL(lat_rad,0) > @toLat
      OR ISNULL(long_rad,0) < @fromLong
      OR ISNULL(long_rad,0) > @toLong)
     AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
   RETURN @@error 
   END
   
   --use cityId
   ELSE IF ( @cityId > 0 )
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
         --AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND cityId != @cityId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
         RETURN @@error 
   END

   --use countyId
   ELSE IF ( @countyId > 0 )
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
         --AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND secondJurisdictionId != @countyId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
         RETURN @@error 
   END

   --use stateId
   ELSE IF ( @stateId > 0 )
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
         --AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND jurisdictionId != @stateId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
      AT ISOLATION READ UNCOMMITTED
      RETURN @@error 
   END

   --use countryId
   ELSE IF ( @countryId > 0 )
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
         --AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND countryId != @countryId
         AND (profileFeatures & 2) > 0
    ORDER BY laston desc, user_id 
      AT ISOLATION READ UNCOMMITTED
      RETURN @@error 
   END
   
   
END



go
EXEC sp_procxmode 'dbo.wsp_getMembNonLocalVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembNonLocalVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembNonLocalVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembNonLocalVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembNonLocalVIP TO web
go
