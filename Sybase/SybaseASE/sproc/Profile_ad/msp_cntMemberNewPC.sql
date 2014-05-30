IF OBJECT_ID('dbo.msp_cntMemberNewPC') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_cntMemberNewPC
    IF OBJECT_ID('dbo.msp_cntMemberNewPC') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_cntMemberNewPC >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_cntMemberNewPC >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  August, 2008
**   Description: count new local members with picture
**
******************************************************************************/
CREATE PROCEDURE msp_cntMemberNewPC
@productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@rowcount int
,@gender char(1)
,@lastonCutoff int
,@lastonSinceCutoff int
,@newSinceCutoff int
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int
,@fromBirthdate datetime
,@toBirthdate  datetime
AS
BEGIN
SET ROWCOUNT @rowcount
IF (@cityId > -1)
    BEGIN
    SELECT
         count(*) as memberCount
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE  @userId >0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND pict = 'Y'
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
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE  @userId >0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND pict = 'Y'
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
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE @userId >0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND pict = 'Y'
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
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE  @userId >0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND pict = 'Y'
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
    FROM a_profile_dating (index ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE  @userId >0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND pictimestamp > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND pict = 'Y'
         AND gender = @gender
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
    END
END



go
EXEC sp_procxmode 'dbo.msp_cntMemberNewPC','unchained'
go
IF OBJECT_ID('dbo.msp_cntMemberNewPC') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_cntMemberNewPC >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_cntMemberNewPC >>>'
go
GRANT EXECUTE ON dbo.msp_cntMemberNewPC TO web
go
