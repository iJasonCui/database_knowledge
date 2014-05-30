IF OBJECT_ID('dbo.wssp_getMembLocalNewGL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getMembLocalNewGL
    IF OBJECT_ID('dbo.wssp_getMembLocalNewGL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getMembLocalNewGL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getMembLocalNewGL >>>'
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
CREATE PROCEDURE wssp_getMembLocalNewGL
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
,@languageMask int
AS
BEGIN
SET ROWCOUNT @rowcount
IF (@toLat <> 0)
BEGIN
    SELECT
         user_id as userId,
         laston
    FROM a_profile_dating  (INDEX ndx_search_latlong) 
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
IF OBJECT_ID('dbo.wssp_getMembLocalNewGL') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getMembLocalNewGL >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getMembLocalNewGL >>>'
go
EXEC sp_procxmode 'dbo.wssp_getMembLocalNewGL','unchained'
go
GRANT EXECUTE ON dbo.wssp_getMembLocalNewGL TO web
go
