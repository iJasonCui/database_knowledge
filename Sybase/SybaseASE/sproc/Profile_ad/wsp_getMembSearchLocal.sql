IF OBJECT_ID('dbo.wsp_getMembSearchLocal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchLocal
    IF OBJECT_ID('dbo.wsp_getMembSearchLocal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchLocal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchLocal >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 20 2002
**   Description:  retrieves list of new members/pics/backstages since
**   cutoff
**
**
** REVISION(S):
**   Author: Anna Deigin and Mike Stairs
**   Date: December 2003
**   Description: added VP type and revised B type to do union with ProfileMedia table
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchLocal
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@type CHAR(2)
,@fromLat NUMERIC(12,0)
,@fromLong NUMERIC(12,0)
,@toLat NUMERIC(12,0)
,@toLong NUMERIC(12,0)
AS
IF @toLat > 0
BEGIN
    DECLARE @fromLatInt  INT
           ,@fromLongInt INT
           ,@toLatInt    INT
           ,@toLongInt   INT

    SELECT @fromLatInt  = CONVERT(INT,@fromLat)
    SELECT @fromLongInt = CONVERT(INT,@fromLong)
    SELECT @toLatInt    = CONVERT(INT,@toLat)
    SELECT @toLongInt   = CONVERT(INT,@toLong)
END

BEGIN
  SET ROWCOUNT @rowcount
  IF ( @type = 'G' AND @toLat > 0)
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND lat_rad >= @fromLatInt
         AND lat_rad <= @toLatInt
         AND long_rad >= @fromLongInt
         AND long_rad <= @toLongInt
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF ( @type = 'G')
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND location_id >= @fromLat
         AND location_id <= @fromLong
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'P' AND @toLat > 0)
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND pict='Y'
         AND lat_rad >= @fromLatInt
         AND lat_rad <= @toLatInt
         AND long_rad >= @fromLongInt
         AND long_rad <= @toLongInt
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'P')
    BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND pict='Y'
         AND location_id >= @fromLat
         AND location_id <= @fromLong
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'B' AND @toLat > 0)
   BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         backstage = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND NOT EXISTS
         (
              SELECT
                   userId
              FROM Blocklist
              WHERE
                 targetUserId=@userId
                 AND userId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND lat_rad >= @fromLatInt
         AND lat_rad <= @toLatInt
         AND long_rad >= @fromLongInt
         AND long_rad <= @toLongInt
    UNION
    SELECT
         user_id as userId,
         laston
    FROM ProfileMedia,  a_profile_dating 
    WHERE ProfileMedia.userId  = a_profile_dating.user_id 
         AND backstageFlag = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND lat_rad >= @fromLatInt
         AND lat_rad <= @toLatInt
         AND long_rad >= @fromLongInt
         AND long_rad <= @toLongInt
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'B')
   BEGIN
    SELECT
      user_id,
      laston
    FROM a_profile_dating
    WHERE
         backstage = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
         AND NOT EXISTS
         (
              SELECT
                   targetUserId
              FROM Blocklist
              WHERE
                 userId=@userId
                 AND targetUserId=a_profile_dating.user_id
         )
         AND NOT EXISTS
         (
              SELECT
                   userId
              FROM Blocklist
              WHERE
                 targetUserId=@userId
                 AND userId=a_profile_dating.user_id
         )
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND location_id >= @fromLat
         AND location_id <= @fromLong
    UNION
    SELECT
         user_id as userId,
         laston
    FROM ProfileMedia, a_profile_dating 
    WHERE ProfileMedia.userId =  a_profile_dating.user_id 
         AND backstageFlag = 'Y'
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND location_id >= @fromLat
         AND location_id <= @fromLong
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END 
  ELSE
  IF (@type = 'VP' AND @toLat > 0)
    BEGIN
    SELECT
      distinct user_id,
      laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND ProfileMedia.mediaType='v'
         AND lat_rad >= @fromLatInt
         AND lat_rad <= @toLatInt
         AND long_rad >= @fromLongInt
         AND long_rad <= @toLongInt
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@type = 'VP')
    BEGIN
    SELECT
      distinct user_id,
      laston
    FROM a_profile_dating,ProfileMedia
    WHERE
         a_profile_dating.user_id=ProfileMedia.userId
         AND show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
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
         AND ProfileMedia.mediaType='v'
         AND location_id >= @fromLat
         AND location_id <= @fromLong
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getMembSearchLocal TO web
go
IF OBJECT_ID('dbo.wsp_getMembSearchLocal') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchLocal >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchLocal >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchLocal','unchained'
go
