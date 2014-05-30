IF OBJECT_ID('dbo.wsp_getMembSearchLocal5Y') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchLocal5Y
    IF OBJECT_ID('dbo.wsp_getMembSearchLocal5Y') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchLocal5Y >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchLocal5Y >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of local members within 5 years age of searcher since cutoff
**
**          
** REVISION(S):
**   Author: Travis McCauley
**   Date:  June 7, 2004
**   Description: Added city db fields for use when no lat long is available
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: added languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchLocal5Y
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
,@matchLanguage bit
AS

BEGIN
  SET ROWCOUNT @rowcount
  IF @toLat <> 0
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND cityId = @cityId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND secondJurisdictionId = @countyId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND jurisdictionId = @stateId
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
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND birthdate  >= @startBirthdate
         AND birthdate <= @endBirthdate
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
      AT ISOLATION READ UNCOMMITTED
      RETURN @@error 
   END
   
   
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembSearchLocal5Y TO web
go
IF OBJECT_ID('dbo.wsp_getMembSearchLocal5Y') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchLocal5Y >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchLocal5Y >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchLocal5Y','unchained'
go
