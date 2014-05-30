IF OBJECT_ID('dbo.wsp_getProfileQuickGL') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileQuickGL
    IF OBJECT_ID('dbo.wsp_getProfileQuickGL') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileQuickGL >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileQuickGL >>>'
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
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use cityDb instead of location_ids
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileQuickGL
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@countryId int,
@stateId int,
@cityId int
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF @cityId > 0
      BEGIN
        SELECT 
            user_id as id,
            laston     
          FROM a_profile_dating (INDEX ndx_search)
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND gender = @gender
               AND cityId = @cityId
          ORDER BY laston desc, user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      end
 ELSE IF @stateId > 0
      BEGIN
        SELECT 
            user_id as id,
            laston     
          FROM a_profile_dating (INDEX ndx_search)
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND gender = @gender
               AND jurisdictionId = @stateId
          ORDER BY laston desc, user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      END
   ELSE IF @countryId > 0
      BEGIN
        SELECT 
            user_id as id,
            laston     
          FROM a_profile_dating (INDEX ndx_search)
          WHERE
               show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
               AND laston > @startingCutoff
               AND laston < @lastonCutoff
               AND gender = @gender
               AND countryId = @countryId
          ORDER BY laston desc, user_id 
          AT ISOLATION READ UNCOMMITTED
          RETURN @@error
      END
END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileQuickGL TO web
go
IF OBJECT_ID('dbo.wsp_getProfileQuickGL') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileQuickGL >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileQuickGL >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileQuickGL','unchained'
go
