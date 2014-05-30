IF OBJECT_ID('dbo.wsp_cntNewLocalMember') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewLocalMember
    IF OBJECT_ID('dbo.wsp_cntNewLocalMember') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewLocalMember >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewLocalMember >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: Oct 2 2002  
**   Description: retrieves the number of members of the given gender whose 
**                profile was created after the given cutoff date.
**          
** REVISION(S):
**   Author: Mike Stairs 
**   Date: Feb 2005
**   Description: eliminated location_id and use languageMask
**
******************************************************************************/
CREATE PROCEDURE  wsp_cntNewLocalMember
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@gender CHAR(1)
,@languageMask INT
,@lastonCutoff INT
,@startingCutoff INT
,@fromLat INT
,@fromLong INT
,@toLat INT
,@toLong INT
AS
BEGIN
IF (@toLat > 0)
  BEGIN
    SELECT    COUNT(*)
    FROM      a_profile_dating
    WHERE     show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y'))
    AND       created_on > @startingCutoff
    AND       laston > @startingCutoff
    AND       laston < @lastonCutoff
    AND       gender = @gender
    AND ISNULL(profileLanguageMask,1) & @languageMask > 0   
    AND       lat_rad >= @fromLat 
    AND       lat_rad <= @toLat
    AND       long_rad >= @fromLong
    AND       long_rad <= @toLong
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
  END	
ELSE
  BEGIN
    SELECT  0
    RETURN @@error
  END
END 
go
GRANT EXECUTE ON dbo.wsp_cntNewLocalMember TO web
go
IF OBJECT_ID('dbo.wsp_cntNewLocalMember') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewLocalMember >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewLocalMember >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntNewLocalMember','unchained'
go
