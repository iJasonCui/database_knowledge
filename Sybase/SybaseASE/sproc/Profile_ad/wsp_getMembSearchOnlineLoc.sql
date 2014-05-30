IF OBJECT_ID('dbo.wsp_getMembSearchOnlineLoc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchOnlineLoc
    IF OBJECT_ID('dbo.wsp_getMembSearchOnlineLoc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchOnlineLoc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchOnlineLoc >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of online local members since lastonCutoff
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
** REVISION(S):
**   Author: Jason Cui
**   Date: Mar 19 2012
**   Description: comment out the online search condition since web business want more result for remote area. 
**
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchOnlineLoc
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@languageMask INT
,@type CHAR(1)
,@fromLat INT
,@fromLong INT
,@toLat INT
,@toLong INT
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int
,@matchLanguage bit
AS

BEGIN

--  SELECT @startingCutoff = @startingCutoff - 2*24*3600

  SET ROWCOUNT @rowcount
  --use lat long
  IF @toLat <> 0
  BEGIN
  SELECT 
      user_id,
      laston     
    FROM a_profile_dating (index ndx_search_latlong)
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
         AND on_line='Y'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use city id
    ELSE IF @cityId > 0
    BEGIN
  SELECT 
      user_id,
      laston     
    FROM a_profile_dating
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
         AND on_line='Y'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND cityId = @cityId
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use countyId
    ELSE IF @countyId > 0
    BEGIN
  SELECT 
      user_id,
      laston     
    FROM a_profile_dating
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
         AND on_line='Y'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND secondJurisdictionId = @countyId
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use stateId
    ELSE IF @stateId > 0
    BEGIN
  SELECT 
      user_id,
      laston     
    FROM a_profile_dating
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
         AND on_line='Y'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND jurisdictionId = @stateId
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use country id
    ELSE IF @countryId > 0
    BEGIN
  SELECT 
      user_id,
      laston     
    FROM a_profile_dating
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
         AND on_line='Y'
         AND gender = @gender
         AND dbo.sp__languageMatched(profileLanguageMask, @languageMask, @matchLanguage) = 1
         AND countryId = @countryId
    ORDER BY laston desc, user_id 
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
END

go
IF OBJECT_ID('dbo.wsp_getMembSearchOnlineLoc') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchOnlineLoc >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchOnlineLoc >>>'
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchOnlineLoc','unchained'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchOnlineLoc TO web
go
