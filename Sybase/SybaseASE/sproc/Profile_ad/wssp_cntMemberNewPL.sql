IF OBJECT_ID('dbo.wssp_cntMemberNewPL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_cntMemberNewPL
    IF OBJECT_ID('dbo.wssp_cntMemberNewPL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_cntMemberNewPL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_cntMemberNewPL >>>'
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
CREATE PROCEDURE wssp_cntMemberNewPL
@productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@rowcount int
,@gender char(1)
,@lastonCutoff int
,@lastonSinceCutoff int
,@newSinceCutoff int
,@fromLat int
,@fromLong int
,@toLat int
,@toLong int
,@fromBirthdate datetime
,@toBirthdate  datetime
AS
BEGIN
SET ROWCOUNT @rowcount
  IF (@toLat <> 0)
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
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
              WHERE @userId >0 AND
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
EXEC sp_procxmode 'dbo.wssp_cntMemberNewPL','unchained'
go
IF OBJECT_ID('dbo.wssp_cntMemberNewPL') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_cntMemberNewPL >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_cntMemberNewPL >>>'
go
GRANT EXECUTE ON dbo.wssp_cntMemberNewPL TO web
go
