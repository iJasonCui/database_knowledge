IF OBJECT_ID('dbo.wssp_cntMemberOnlineGC') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_cntMemberOnlineGC
    IF OBJECT_ID('dbo.wssp_cntMemberOnlineGC') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_cntMemberOnlineGC >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_cntMemberOnlineGC >>>'
END
/******************************************************************************
**
** CREATION:
**   Author:  Frank Qi
**   Date:  August, 2008  
**   Description:  count local online members 
******************************************************************************/
go
CREATE PROCEDURE  wssp_cntMemberOnlineGC
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@lastonSinceCutoff int,
@countryId smallint,
@stateId smallint,
@countyId smallint,
@cityId  int,
@fromBirthdate datetime,
@toBirthdate  datetime
AS
BEGIN
SET ROWCOUNT @rowcount

IF (@cityId > -1) 
    BEGIN
    SELECT 
      count(*) as memberCount 
    FROM a_profile_dating (index ndx_search_cityId)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
               SELECT targetUserId
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId  
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND cityId = @cityId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate             
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1) 
    BEGIN
    SELECT 
      count(*) as memberCount
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND secondJurisdictionId = @countyId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate           
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1) 
    BEGIN
    SELECT 
      count(*) as memberCount 
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND jurisdictionId = @stateId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > 0) 
    BEGIN
    SELECT 
      count(*) as memberCount
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND countryId = @countryId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE 
    BEGIN
         SELECT 
      count(*) as memberCount
    FROM a_profile_dating (index ndx_search)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
         )
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff             
         AND on_line='Y'
         AND gender = @gender
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate                 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
    END
END



go
EXEC sp_procxmode 'dbo.wssp_cntMemberOnlineGC','unchained'
go
IF OBJECT_ID('dbo.wssp_cntMemberOnlineGC') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_cntMemberOnlineGC >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_cntMemberOnlineGC >>>'
go
GRANT EXECUTE ON dbo.wssp_cntMemberOnlineGC TO web
go
