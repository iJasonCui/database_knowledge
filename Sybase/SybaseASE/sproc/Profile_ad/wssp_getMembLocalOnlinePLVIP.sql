IF OBJECT_ID('dbo.wssp_getMembLocalOnlinePLVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getMembLocalOnlinePLVIP
    IF OBJECT_ID('dbo.wssp_getMembLocalOnlinePLVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getMembLocalOnlinePLVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getMembLocalOnlinePLVIP >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Yadira Genoves X
**   Date:  July 2009
**   Description: Get VIP people
**
******************************************************************************/
CREATE PROCEDURE  wssp_getMembLocalOnlinePLVIP
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
@toBirthdate  datetime,
@languageMask int
AS
BEGIN
SET ROWCOUNT @rowcount
  IF (@toLat <> 0)
  BEGIN
    SELECT
      user_id as userId,
      laston     
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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND on_line='Y'
         AND pict='Y'
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         AND birthdate >= @fromBirthdate
         AND birthdate <= @toBirthdate              
         AND (profileFeatures & 2) > 0
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
EXEC sp_procxmode 'dbo.wssp_getMembLocalOnlinePLVIP','unchained'
go
IF OBJECT_ID('dbo.wssp_getMembLocalOnlinePLVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getMembLocalOnlinePLVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getMembLocalOnlinePLVIP >>>'
go
GRANT EXECUTE ON dbo.wssp_getMembLocalOnlinePLVIP TO web
go
