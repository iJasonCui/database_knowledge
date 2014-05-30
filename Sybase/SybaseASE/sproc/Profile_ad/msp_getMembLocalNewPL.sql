IF OBJECT_ID('dbo.msp_getMembLocalNewPL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getMembLocalNewPL
    IF OBJECT_ID('dbo.msp_getMembLocalNewPL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getMembLocalNewPL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getMembLocalNewPL >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Frank Qi
**   Date:  August, 2008
**   Description: get new local members with picture
**
******************************************************************************/
CREATE PROCEDURE msp_getMembLocalNewPL
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
         user_id as userId,
         laston
    FROM a_profile_dating (index ndx_picttime)
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
EXEC sp_procxmode 'dbo.msp_getMembLocalNewPL','unchained'
go
IF OBJECT_ID('dbo.msp_getMembLocalNewPL') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_getMembLocalNewPL >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getMembLocalNewPL >>>'
go
GRANT EXECUTE ON dbo.msp_getMembLocalNewPL TO web
go
