IF OBJECT_ID('dbo.wsp_getGreenlightGPAJuris') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGreenlightGPAJuris
    IF OBJECT_ID('dbo.wsp_getGreenlightGPAJuris') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGreenlightGPAJuris >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGreenlightGPAJuris >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 26, 2005  
**   Description:  retrieves list of members for greenlight quick form (by gender, picture, age, and jurisdictionId)
**   lastonCutoff.
**
**
******************************************************************************/
CREATE PROCEDURE wsp_getGreenlightGPAJuris
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1),
@fromAge datetime,
@toAge  datetime,
@jurisdictionId  int
AS
BEGIN
  SET ROWCOUNT @rowcount
  SELECT 
               user_id,
               @gender,
               birthdate,
	       headline,
               myidentity,
               height_cm,
               height_in,
               attributes,
               noshowdescrp,
               countryId,
               jurisdictionId,
               secondJurisdictionId,
               cityId
    FROM a_profile_dating (INDEX ndx_search_pict)
    WHERE
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND pict=@pictureFlag
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND jurisdictionId = @jurisdictionId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getGreenlightGPAJuris TO web
go
IF OBJECT_ID('dbo.wsp_getGreenlightGPAJuris') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGreenlightGPAJuris >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGreenlightGPAJuris >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGreenlightGPAJuris','unchained'
go
