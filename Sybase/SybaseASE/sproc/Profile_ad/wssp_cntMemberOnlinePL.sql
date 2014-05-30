
IF OBJECT_ID('dbo.wssp_cntMemberOnlinePL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_cntMemberOnlinePL
    IF OBJECT_ID('dbo.wssp_cntMemberOnlinePL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_cntMemberOnlinePL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_cntMemberOnlinePL >>>'
END
/******************************************************************************
**
** CREATION:
**   Author:  Frank Qi
**   Date:  August, 2008  
**   Description:  count local online members with picture
******************************************************************************/
go
CREATE PROCEDURE  wssp_cntMemberOnlinePL
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@lastonSinceCutoff int,
@fromLat int,
@fromLong int,
@toLat int,
@toLong int,
@fromBirthdate datetime,
@toBirthdate  datetime
AS
BEGIN
SET ROWCOUNT @rowcount
  IF (@toLat <> 0)
  BEGIN
    SELECT
      count(*) as memberCount
    FROM a_profile_dating (index ndx_search_pict)
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
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
         AND gender = @gender
         AND on_line='Y'
         AND pict='Y'
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate              
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END

go
EXEC sp_procxmode 'dbo.wssp_cntMemberOnlinePL','unchained'
go
IF OBJECT_ID('dbo.wssp_cntMemberOnlinePL') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_cntMemberOnlinePL >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_cntMemberOnlinePL >>>'
go
GRANT EXECUTE ON dbo.wssp_cntMemberOnlinePL TO web
go
