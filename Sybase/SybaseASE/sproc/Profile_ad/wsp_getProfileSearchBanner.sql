IF OBJECT_ID('dbo.wsp_getProfileSearchBanner') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchBanner
    IF OBJECT_ID('dbo.wsp_getProfileSearchBanner') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchBanner >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchBanner >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 9 2002  
**   Description:  retrieves list of members since lastonCutoff using banner
**                 key as type lookup
**
**          
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE  wsp_getProfileSearchBanner
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@rowcount INT
,@gender CHAR(1)
,@lastonCutoff INT
,@startingCutoff INT
,@type VARCHAR(30)
AS
BEGIN
  SET ROWCOUNT @rowcount
  IF ( @type = 'TRAVEL') 
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND hobbies & 4194304 > 0
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'OUTDOOR')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND outdoors & 312332 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'MOVIES')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND entertainment & 512 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'DINNING') -- mispelled dining - what can you do...
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND entertainment & 256 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'WORKOUT')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND outdoors & 131073 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'LIVEMUSIC')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND entertainment & 4 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'THEATER')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND entertainment & 8 > 0 
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  ELSE
  IF (@type = 'PETS')
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
         AND hobbies & 1288 > 0
    ORDER BY laston desc, user_id 
    RETURN @@error
  END
  -- else default is search for pictures
  ELSE
    BEGIN
    SELECT 
      user_id,
      laston     
    FROM a_profile_dating
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff             
         AND gender = @gender
         AND pict='Y'
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END
END 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchBanner TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchBanner') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchBanner >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchBanner >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchBanner','unchained'
go
