IF OBJECT_ID('dbo.msp_cntMemberOnline') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_cntMemberOnline
    IF OBJECT_ID('dbo.msp_cntMemberOnline') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_cntMemberOnline >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_cntMemberOnline >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Frank Qi
**   Date:  July 30, 2008  
**   Description:  get count of online and/or new members
**   This is retired and please use version that has sufix 
**
**
******************************************************************************/
CREATE PROCEDURE  msp_cntMemberOnline
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@lastonSinceCutoff int,
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
@fromBirthdate datetime,
@toBirthdate  datetime
AS
BEGIN
SET ROWCOUNT @rowcount
IF ( @type = 'G' OR @type='L') -- searcl by gender/local
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT count(*) as memberCount    
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff          
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate         
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@cityId > -1) 
    BEGIN
    SELECT count(*) as memberCount  
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId = @cityId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate             
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1) 
    BEGIN
    SELECT count(*) as memberCount    
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId = @countyId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate           
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1) 
    BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId = @stateId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > 0) 
    BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId = @countryId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE 
    BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                 
    AT ISOLATION READ UNCOMMITTED 
      RETURN @@error
    END
    END
ELSE
IF (@type = 'P') -- search with picture
BEGIN
  IF (@toLat <> 0)
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate              
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@cityId > -1)
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND on_line='Y'
         AND pict='Y'
         AND cityId = @cityId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1)
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId = @countyId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate         
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1)
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId = @stateId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate           
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > 0)
  BEGIN
    SELECT count(*) as memberCount  
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId = @countryId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE 
  BEGIN
    SELECT count(*) as memberCount  
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    AT ISOLATION READ UNCOMMITTED 
    RETURN @@error
  END
  END
ELSE
IF (@type = 'B') -- with backsatge
BEGIN
  --use square
  IF (@toLat <> 0)
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND (backstage='Y' or user_id in (select userId from ProfileMedia where backstageFlag = 'Y'))
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate       
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use city id
  ELSE IF (@cityId > -1) 
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND (backstage='Y' or user_id in (select userId from ProfileMedia where backstageFlag = 'Y'))
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId = @cityId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  --use secondary jurisdiction id
  ELSE  IF (@countyId > -1) 
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND (backstage='Y' or user_id in (select userId from ProfileMedia where backstageFlag = 'Y'))
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId = @countyId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate    
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use jurisdiction id
  ELSE  IF (@stateId > -1) 
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND (backstage='Y' or user_id in (select userId from ProfileMedia where backstageFlag = 'Y'))
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId = @stateId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  -- use country id
  ELSE  IF (@countryId > -1) 
  BEGIN
    SELECT count(*) as memberCount   
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND (backstage='Y' or user_id in (select userId from ProfileMedia where backstageFlag = 'Y'))
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId = @countryId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate             
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

EXEC sp_procxmode 'dbo.msp_cntMemberOnline','unchained'
go
IF OBJECT_ID('dbo.msp_cntMemberOnline') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_cntMemberOnline >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_cntMemberOnline >>>'
go
GRANT EXECUTE ON dbo.msp_cntMemberOnline TO web
go
