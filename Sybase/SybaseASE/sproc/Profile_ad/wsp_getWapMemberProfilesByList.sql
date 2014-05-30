IF OBJECT_ID('dbo.wsp_getWapMemberProfilesByList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWapMemberProfilesByList
    IF OBJECT_ID('dbo.wsp_getWapMemberProfilesByList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWapMemberProfilesByList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWapMemberProfilesByList >>>'
END
go
 
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 26, 2006
**   Description:  retrieves profile by userId for wap search results
**
******************************************************************************/
CREATE PROCEDURE  wsp_getWapMemberProfilesByList
@id1 numeric (12,0),
@id2 numeric (12,0),
@id3 numeric (12,0),
@id4 numeric (12,0),
@id5 numeric (12,0),
@id6 numeric (12,0)
AS
BEGIN
    SELECT
           user_id,
           gender,
           birthdate,
           headline,
           myidentity,
           approved,
           approved_on,
           laston,
           created_on,
           on_line,
           show,
           pict,
           zodiac_sign,
           height_cm,
           noshowdescrp,
           lat_rad,
           long_rad,
           attributes,
           backstage,
           pictimestamp,
           backstagetimestamp,
           outdoors,
           sportsWatch,
           entertainment,
           hobbies,
           video,
           languagesSpokenMask,
           profileLanguageMask,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId,
           sportsParticipate
    FROM a_profile_dating
    WHERE user_id in (@id1,@id2,@id3,@id4,@id5,@id6)
    ORDER BY laston desc, user_id
    AT ISOLATION READ UNCOMMITTED
   RETURN @@error
  END 
 
go
GRANT EXECUTE ON dbo.wsp_getWapMemberProfilesByList TO web
go
IF OBJECT_ID('dbo.wsp_getWapMemberProfilesByList') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getWapMemberProfilesByList >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWapMemberProfilesByList >>>'
go
EXEC sp_procxmode 'dbo.wsp_getWapMemberProfilesByList','unchained'
go
