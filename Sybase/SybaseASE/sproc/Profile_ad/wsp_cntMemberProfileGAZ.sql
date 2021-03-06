IF OBJECT_ID('dbo.wsp_cntMemberProfileGAZ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntMemberProfileGAZ
    IF OBJECT_ID('dbo.wsp_cntMemberProfileGAZ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntMemberProfileGAZ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntMemberProfileGAZ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Francisc Schonberger
**   Date:  Oct 2004
**   Description:  counts members from quick form by gender, age , and zip(lat,long)
**   lastonCutoff.
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_cntMemberProfileGAZ
@productCode char(1),
@communityCode char(1),
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@fromAge datetime,
@toAge  datetime,
@fromLat int,
@fromLong int,
@toLat int,
@toLong int,
@userId NUMERIC(12,0)

AS
BEGIN
    declare @userCount int
    select @userCount = count(*)
    FROM a_profile_dating (INDEX XIE_search_latlong)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
   AND birthdate >= @toAge
         AND lat_rad >= @fromLat
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
         /*
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
      FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_romance.user_id
         )
         */
    AT ISOLATION READ UNCOMMITTED
    select @userCount
    RETURN @@error
END
go
IF OBJECT_ID('dbo.wsp_cntMemberProfileGAZ') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntMemberProfileGAZ >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntMemberProfileGAZ >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntMemberProfileGAZ','unchained'
go
GRANT EXECUTE ON dbo.wsp_cntMemberProfileGAZ TO web
go
