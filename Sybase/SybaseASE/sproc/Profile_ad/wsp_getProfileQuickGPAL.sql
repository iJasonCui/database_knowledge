IF OBJECT_ID('dbo.wsp_getProfileQuickGPAL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGPAL
    IF OBJECT_ID('dbo.wsp_getProfileQuickGPAL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGPAL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGPAL >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 15 2002  
**   Description:  retrieves list of members from quick form (by gender, picture, and location)
**   lastonCutoff.
**
**          
** REVISION(S): 
**   Author: Travis McCauley
**   Date: June 16, 2004
**   Description: Added country/state id fields to use new city db fields for searching from the flash entrance page.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use cityDb instead of location_ids
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGPAL
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1),
@fromAge datetime,
@toAge  datetime,
@countryId int,
@stateId int,
@cityId int

AS
BEGIN

--  SELECT @startingCutoff = DATEDIFF(ss, "Jan 1 1970", DATEADD(month, -120, getdate()))

  SET ROWCOUNT @rowcount
   IF @cityId > 0
      BEGIN
        SELECT 
            profile.user_id as id,
            laston     
          FROM a_profile_dating as profile --, IntelligentPick as pick
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND profile.gender = @gender
               AND pict=@pictureFlag
               AND birthdate <= @fromAge
               AND birthdate >= @toAge
               AND cityId = @cityId 
          --     AND profile.user_id = pick.user_id 
          ORDER BY laston desc, profile.user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      END
   ELSE IF @stateId > 0
      BEGIN
        SELECT 
            profile.user_id as id,
            laston     
          FROM a_profile_dating as profile --, IntelligentPick as pick
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND profile.gender = @gender
               AND pict=@pictureFlag
               AND birthdate <= @fromAge
               AND birthdate >= @toAge
               AND jurisdictionId = @stateId
          --     AND profile.user_id = pick.user_id 
          ORDER BY laston desc, profile.user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      end
   ELSE IF @countryId > 0
      BEGIN
        SELECT 
            profile.user_id as id,
            laston     
          FROM a_profile_dating as profile --, IntelligentPick as pick
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND profile.gender = @gender
               AND pict=@pictureFlag
               AND birthdate <= @fromAge
               AND birthdate >= @toAge
               AND countryId = @countryId
          --     AND profile.user_id = pick.user_id 
          ORDER BY laston desc, profile.user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      END
END
  
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGPAL TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGPAL') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGPAL >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGPAL >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGPAL','unchained'
go
