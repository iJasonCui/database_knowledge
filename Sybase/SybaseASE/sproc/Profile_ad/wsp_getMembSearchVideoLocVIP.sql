IF OBJECT_ID('dbo.wsp_getMembSearchVideoLocVIP') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchVideoLocVIP
    IF OBJECT_ID('dbo.wsp_getMembSearchVideoLocVIP') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchVideoLocVIP >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchVideoLocVIP >>>'
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
CREATE PROCEDURE  wsp_getMembSearchVideoLocVIP
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@type char(2),
@fromLat NUMERIC(12,0),
@fromLong NUMERIC(12,0),
@toLat NUMERIC(12,0),
@toLong NUMERIC(12,0)
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int

AS

IF @toLat <> 0
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
  
   IF (@toLat <> 0)
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
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  
  --use cityId
  ELSE IF @cityId > 0
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
         AND cityId = @cityId
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use countyId
  ELSE IF @countyId > 0
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
         AND secondJurisdictionId = @countyId
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use stateId
  ELSE IF @stateId > 0
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
         AND jurisdictionId = @stateId
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

  --use countryId
  ELSE IF @countryId > 0
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
         AND countryId = @countryId
         AND (a_profile_dating.profileFeatures & 2) > 0
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchVideoLocVIP','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchVideoLocVIP') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchVideoLocVIP >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchVideoLocVIP >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchVideoLocVIP TO web
go
