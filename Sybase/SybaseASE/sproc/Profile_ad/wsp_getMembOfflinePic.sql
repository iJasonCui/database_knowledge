IF OBJECT_ID('dbo.wsp_getMembOfflinePic') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembOfflinePic
    IF OBJECT_ID('dbo.wsp_getMembOfflinePic') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembOfflinePic >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembOfflinePic >>>'
END
go

CREATE PROCEDURE  wsp_getMembOfflinePic
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
@languageMask int,
@matchLanguage bit
AS

    SELECT @startingCutoff = @startingCutoff - 7 * 24 * 60 * 60

    SET ROWCOUNT @rowcount

    SELECT
      user_id,
      laston     
    FROM a_profile_dating (index ndx_search_pict)
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
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND on_line='N'
         AND pict='Y'
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error


go
EXEC sp_procxmode 'dbo.wsp_getMembOfflinePic','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembOfflinePic') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembOfflinePic >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembOfflinePic >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembOfflinePic TO web
go
