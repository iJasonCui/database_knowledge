IF OBJECT_ID('dbo.wsp_getIcqSearchResult') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getIcqSearchResult
    IF OBJECT_ID('dbo.wsp_getIcqSearchResult') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getIcqSearchResult >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getIcqSearchResult >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 2 2004
**   Description:  Retrieves icq search results
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  April 2004
**   Description: return some extra columns
**
** REVISION(S): 
**   Author: Mike Stairs
**   Date: May 2004
**   Description: get cityDB ids
**
** REVISION(S): 
**   Author: Mike Stairs
**   Date: May 2004
**   Description: use countryId instead of location_id for searches
**
*************************************************************************/

CREATE PROCEDURE  wsp_getIcqSearchResult
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@rowcount INT
,@lastonCutoff INT
,@startingCutoff INT
,@gender CHAR(1)
,@fromAge DATETIME
,@toAge  DATETIME
,@countryId INT

AS
BEGIN
    SET ROWCOUNT @rowcount

    IF @countryId > -1
     BEGIN
	SELECT user_id,
               gender,
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
       FROM   a_profile_dating --(INDEX ndx_search_pict) 
       WHERE  
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND pict = 'Y'
         AND countryId = @countryId
       ORDER BY laston desc, user_id 
       AT ISOLATION READ UNCOMMITTED
    END
    ELSE
     BEGIN
	SELECT user_id,
               gender,
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
       FROM   a_profile_dating --(INDEX ndx_search_pict)
       WHERE  
         show='Y' AND (show_prefs='Y' OR (show_prefs='O' and on_line='Y')) 
         AND laston > @startingCutoff
         AND laston < @lastonCutoff
         AND gender = @gender
         AND birthdate <= @fromAge
         AND birthdate >= @toAge
         AND pict = 'Y'
         AND (countryId = 244 OR countryId = 40)
       ORDER BY laston desc, user_id 
       AT ISOLATION READ UNCOMMITTED
    END

    RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getIcqSearchResult TO web
go
IF OBJECT_ID('dbo.wsp_getIcqSearchResult') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getIcqSearchResult >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getIcqSearchResult >>>'
go
EXEC sp_procxmode 'dbo.wsp_getIcqSearchResult','unchained'
go
