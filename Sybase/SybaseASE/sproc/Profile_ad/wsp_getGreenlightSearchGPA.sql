IF OBJECT_ID('dbo.wsp_getGreenlightGPA') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getGreenlightGPA
    IF OBJECT_ID('dbo.wsp_getGreenlightGPA') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getGreenlightGPA >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getGreenlightGPA >>>'
END
go
    /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Jan 26, 2005  
**   Description:  retrieves list of members for greenlight quick form (by gender, picture and age)
**   lastonCutoff.
**
**
******************************************************************************/
CREATE PROCEDURE wsp_getGreenlightGPA
@productCode char(1),
@communityCode char(1),
@rowcount int,
@gender char(1),
@lastonCutoff int,
@startingCutoff int,
@pictureFlag char(1),
@fromAge datetime,
@toAge  datetime
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
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
    RETURN @@error
   END
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getGreenlightGPA TO web
go
IF OBJECT_ID('dbo.wsp_getGreenlightGPA') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getGreenlightGPA >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getGreenlightGPA >>>'
go
EXEC sp_procxmode 'dbo.wsp_getGreenlightGPA','unchained'
go
