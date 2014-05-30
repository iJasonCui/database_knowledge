IF OBJECT_ID('dbo.wsp_getProfileSearchLoc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchLoc
    IF OBJECT_ID('dbo.wsp_getProfileSearchLoc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchLoc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchLoc >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves list of members by location range since
**   lastonCutoff.
**
**          
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: use cityDb instead of location_ids
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileSearchLoc
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@countryId int,
@stateId int,
@countyId int,
@cityId int
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF (@cityId > 0) 
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND cityId = @cityId
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@countyId > 0) 
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND secondJurisdictionId = @countyId
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@stateId > 0) 
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND jurisdictionId = @stateId
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
  IF (@countryId > 0) 
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND countryId = @countryId
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
  ELSE
    BEGIN
    SELECT 
      user_id as id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchLoc TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchLoc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchLoc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchLoc >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchLoc','unchained'
go
