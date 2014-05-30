IF OBJECT_ID('dbo.wsp_getGreenlightGPACity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGreenlightGPACity
    IF OBJECT_ID('dbo.wsp_getGreenlightGPACity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGreenlightGPACity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGreenlightGPACity >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 26, 2005  
**   Description:  retrieves list of members for greenlight quick form (by gender, picture, age, and cityId)
**   lastonCutoff.
**
**
******************************************************************************/
CREATE PROCEDURE wsp_getGreenlightGPACity
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1),
@fromAge datetime,
@toAge  datetime,
@cityId  int
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
         AND cityId = @cityId
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getGreenlightGPACity TO web
go
IF OBJECT_ID('dbo.wsp_getGreenlightGPACity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGreenlightGPACity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGreenlightGPACity >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGreenlightGPACity','unchained'
go
