IF OBJECT_ID('dbo.wsp_getSearchVideoLoc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSearchVideoLoc
    IF OBJECT_ID('dbo.wsp_getSearchVideoLoc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSearchVideoLoc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSearchVideoLoc >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  Feb 2004
**   Description:  local video search
**
** REVISION(S):
**   Author: Travis McCauley
**   Date:  June 7, 2004
**   Description: Added city db fields for use when no lat long is available
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: added languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_getSearchVideoLoc
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@languageMask int,
@type char(2),
@fromLat int,
@fromLong int,
@toLat int,
@toLong int
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int

AS

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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ProfileMedia.mediaType='v'
         AND lat_rad >= @fromLat
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ProfileMedia.mediaType='v'
         AND cityId = @cityId
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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ProfileMedia.mediaType='v'
         AND secondJurisdictionId = @countyId
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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ProfileMedia.mediaType='v'
         AND jurisdictionId = @stateId
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
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND ProfileMedia.mediaType='v'
         AND countryId = @countryId
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END

END


go
GRANT EXECUTE ON dbo.wsp_getSearchVideoLoc TO web
go
IF OBJECT_ID('dbo.wsp_getSearchVideoLoc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSearchVideoLoc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSearchVideoLoc >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSearchVideoLoc','unchained'
go
