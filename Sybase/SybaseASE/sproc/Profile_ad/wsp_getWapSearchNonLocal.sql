IF OBJECT_ID('dbo.wsp_getWapSearchNonLocal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWapSearchNonLocal
    IF OBJECT_ID('dbo.wsp_getWapSearchNonLocal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWapSearchNonLocal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWapSearchNonLocal >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Sept 26, 2006
**   Description: non-local browse searches for wap members
**
******************************************************************************/
CREATE PROCEDURE  wsp_getWapSearchNonLocal
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictFlag char(1),
@countryId smallint,
@stateId smallint,
@cityId  int,
@languageMask int,
@fromAge datetime,
@toAge datetime,
@type char(2)
AS
BEGIN
SET ROWCOUNT @rowcount
IF ( @type = 'P' ) 
BEGIN
 IF (@cityId > -1) 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating -- --(INDEX ndx_search)
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
         AND ISNULL(pict,'N') ='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId != @cityId
         AND jurisdictionId = @stateId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
 ELSE IF (@stateId > -1) 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating -- --(INDEX ndx_search)
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
         AND ISNULL(pict,'N') ='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId != @stateId
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search)
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
         AND ISNULL(pict,'N')='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId != @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
IF ( @type = 'PA' ) 
BEGIN
 IF (@cityId > -1) 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating -- --(INDEX ndx_search)
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
         AND ISNULL(pict,'N')='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId != @cityId
         AND jurisdictionId = @stateId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
 ELSE IF (@stateId > -1) 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating -- --(INDEX ndx_search)
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
         AND ISNULL(pict,'N')='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId != @stateId
         AND countryId = @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE 
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search)
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
         AND ISNULL(pict,'N')='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId != @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
ELSE IF (@type = 'A') -- age only specified
BEGIN
 IF (@cityId > -1)
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND cityId != @cityId
         AND jurisdictionId = @stateId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
 ELSE IF (@stateId > -1)
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND jurisdictionId != @stateId
         AND countryId = @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND countryId != @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
ELSE -- no pic or age
BEGIN
 IF (@cityId > -1)
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND cityId != @cityId
         AND jurisdictionId = @stateId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
 ELSE IF (@stateId > -1)
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND jurisdictionId != @stateId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating --(INDEX ndx_search_pict)
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
         AND countryId != @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getWapSearchNonLocal TO web
go
IF OBJECT_ID('dbo.wsp_getWapSearchNonLocal') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getWapSearchNonLocal >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWapSearchNonLocal >>>'
go
EXEC sp_procxmode 'dbo.wsp_getWapSearchNonLocal','unchained'
go
