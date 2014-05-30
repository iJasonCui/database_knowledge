IF OBJECT_ID('dbo.wsp_getWapSearchLocal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWapSearchLocal
    IF OBJECT_ID('dbo.wsp_getWapSearchLocal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWapSearchLocal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWapSearchLocal >>>'
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
CREATE PROCEDURE  wsp_getWapSearchLocal
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
IF ( @type = 'P' ) -- qucik search with pic and no age specified
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
         AND cityId = @cityId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF @stateId > -1
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
IF ( @type = 'PA' ) -- quick search with pic and age specified
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
         AND cityId = @cityId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
ELSE IF (@type = 'A') -- quick search with age but no pic
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
         AND cityId = @cityId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
ELSE -- no pic or age specified
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
         AND cityId = @cityId
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
         AND jurisdictionId = @stateId
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
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getWapSearchLocal TO web
go
IF OBJECT_ID('dbo.wsp_getWapSearchLocal') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getWapSearchLocal >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWapSearchLocal >>>'
go
EXEC sp_procxmode 'dbo.wsp_getWapSearchLocal','unchained'
go
