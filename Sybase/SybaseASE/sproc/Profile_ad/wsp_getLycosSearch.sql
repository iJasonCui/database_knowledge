IF OBJECT_ID('dbo.wsp_getLycosSearch') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getLycosSearch
    IF OBJECT_ID('dbo.wsp_getLycosSearch') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getLycosSearch >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getLycosSearch >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  August 9, 2005  
**   Description:  retrieves list of members for Lycos (by gender, picture, age, countryId
**                 lastonCutoff).
**
**
******************************************************************************/
CREATE PROCEDURE wsp_getLycosSearch
    @productCode   CHAR(1),
    @communityCode CHAR(1),
    @rowcount      INT,
    @startLaston   INT,
    @endLaston     INT,
    @countryId     INT 
AS
BEGIN
    SET ROWCOUNT @rowcount
    SELECT p.user_id,
           p.gender,
           convert(varchar(20), dateadd(ss, p.created_on, 'jan 1 1970'), 107),  
           convert(varchar(20), p.birthdate, 107),
           p.headline,
           p.myidentity,
           p.height_in,
           p.attributes,
           p.jurisdictionId,
           p.secondJurisdictionId,
           p.cityId,
           p.zipcode,
           p.languagesSpokenMask,
           p.entertainment,
           p.hobbies,
           p.outdoors,
           p.sportsWatch,
           p.sportsParticipate,
           w.utext,
           p.laston
      FROM a_profile_dating p, a_dating w 
     WHERE p.show = 'Y' 
       AND p.show_prefs = 'Y'
       AND p.laston >  @startLaston
       AND p.laston <= @endLaston
       AND p.pict = 'Y' 
       AND p.countryId = @countryId
       AND p.user_id = w.user_id
    ORDER BY p.laston DESC 
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getLycosSearch TO web
go

IF OBJECT_ID('dbo.wsp_getLycosSearch') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getLycosSearch >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getLycosSearch >>>'
go

EXEC sp_procxmode 'dbo.wsp_getLycosSearch','unchained'
go
