IF OBJECT_ID('dbo.wsp_getOnlineLocalCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOnlineLocalCount
    IF OBJECT_ID('dbo.wsp_getOnlineLocalCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOnlineLocalCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOnlineLocalCount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  May 5 2010  
**   Description:  get Online local count to match the result of wsp_getOnlineLocalCount 
**          
**
******************************************************************************/
CREATE PROCEDURE  wsp_getOnlineLocalCount
 @gender CHAR(1)
,@startingCutoff INT
,@languageMask INT
,@fromLat INT
,@fromLong INT
,@toLat INT
,@toLong INT
,@countryId smallint
,@stateId smallint
,@countyId smallint
,@cityId  int
AS

BEGIN
  --use lat long
  IF @toLat <> 0
  BEGIN

    SELECT count(*) 
    FROM a_profile_dating (index ndx_search_latlong)
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND lat_rad >= @fromLat 
         AND lat_rad <= @toLat
         AND long_rad >= @fromLong
         AND long_rad <= @toLong
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use city id
    ELSE IF @cityId > 0
    BEGIN

    SELECT count(*)
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND cityId = @cityId
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use countyId
    ELSE IF @countyId > 0
    BEGIN

    SELECT count(*)
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND secondJurisdictionId = @countyId
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use stateId
    ELSE IF @stateId > 0
    BEGIN

    SELECT count(*)
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND jurisdictionId = @stateId
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
    --use country id
    ELSE IF @countryId > 0
    BEGIN

    SELECT count(*)
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR show_prefs='O') 
         AND laston > @startingCutoff
         AND on_line='Y'
         AND gender = @gender
         AND ISNULL(profileLanguageMask,1) & @languageMask > 0
         AND countryId = @countryId
        AT ISOLATION READ UNCOMMITTED
        RETURN @@error 
    END
    
END

go
IF OBJECT_ID('dbo.wsp_getOnlineLocalCount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getOnlineLocalCount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOnlineLocalCount >>>'
go
EXEC sp_procxmode 'dbo.wsp_getOnlineLocalCount','unchained'
go
GRANT EXECUTE ON dbo.wsp_getOnlineLocalCount TO web
go
