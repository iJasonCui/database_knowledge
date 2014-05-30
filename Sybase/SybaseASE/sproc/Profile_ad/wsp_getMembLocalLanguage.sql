IF OBJECT_ID('dbo.wsp_getMembLocalLanguage') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembLocalLanguage
    IF OBJECT_ID('dbo.wsp_getMembLocalLanguage') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembLocalLanguage >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembLocalLanguage >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Jan 25, 2005
**   Description: localized searches by language
**
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembLocalLanguage
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
@languageMask int
AS
BEGIN
SET ROWCOUNT @rowcount
IF ( @type = 'BS') 
BEGIN
  IF (@toLat <> 0)
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND ISNULL(languagesSpokenMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND cityId = @cityId
         AND ISNULL(languagesSpokenMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND secondJurisdictionId = @countyId
         AND ISNULL(languagesSpokenMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND jurisdictionId = @stateId
         AND ISNULL(languagesSpokenMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND countryId = @countryId
         AND ISNULL(languagesSpokenMask,1) & @languageMask > 0
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
IF (@type = 'BP')
BEGIN
  IF (@toLat <> 0)
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND cityId = @cityId
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND secondJurisdictionId = @countyId
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND jurisdictionId = @stateId
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND countryId = @countryId
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
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
ELSE  -- should never get here!!!!
  BEGIN
    SELECT 0 WHERE 0=1
    RETURN @@error
  END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembLocalLanguage TO web
go
IF OBJECT_ID('dbo.wsp_getMembLocalLanguage') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembLocalLanguage >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembLocalLanguage >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembLocalLanguage','unchained'
go
