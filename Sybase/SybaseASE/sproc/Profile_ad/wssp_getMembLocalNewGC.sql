IF OBJECT_ID('dbo.wssp_getMembLocalNewGC') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getMembLocalNewGC
    IF OBJECT_ID('dbo.wssp_getMembLocalNewGC') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getMembLocalNewGC >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getMembLocalNewGC >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  August, 2008
**   Description: get new local members
**
******************************************************************************/
CREATE PROCEDURE wssp_getMembLocalNewGC
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
,@languageMask int
AS
BEGIN
SET ROWCOUNT @rowcount

  IF (@cityId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_cityId)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND created_on > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId = @cityId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countyId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_latlong)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND created_on > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId = @countyId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@stateId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_latlong )
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND created_on > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId = @stateId
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate  
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE IF (@countryId > -1) 
    BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_search_latlong )
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE @userId>0 AND
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND created_on > @newSinceCutoff
         AND laston > @lastonSinceCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
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

go
IF OBJECT_ID('dbo.wssp_getMembLocalNewGC') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getMembLocalNewGC >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getMembLocalNewGC >>>'
go
EXEC sp_procxmode 'dbo.wssp_getMembLocalNewGC','unchained'
go
GRANT EXECUTE ON dbo.wssp_getMembLocalNewGC TO web
go
