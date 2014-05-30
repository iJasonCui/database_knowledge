IF OBJECT_ID('dbo.wsp_getProfileByUserIdList12') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileByUserIdList12
    IF OBJECT_ID('dbo.wsp_getProfileByUserIdList12') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileByUserIdList12 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileByUserIdList12 >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves profile by userId
**
** REVISION(S): 
**   Author: Mike Stairs
**   Date: May 2004
**   Description: get cityDB ids
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column selects
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: December 2004
**   Description: retrieve 12 results
**
******************************************************************************/
CREATE PROCEDURE wsp_getProfileByUserIdList12
@part_id char(1),
@seg_id char(1),
@id1 numeric (12,0),
@id2 numeric (12,0),
@id3 numeric (12,0),
@id4 numeric (12,0),
@id5 numeric (12,0),
@id6 numeric (12,0),
@id7 numeric (12,0),
@id8 numeric (12,0),
@id9 numeric (12,0),
@id10 numeric (12,0),
@id11 numeric (12,0),
@id12 numeric (12,0)

AS
BEGIN
    SELECT 
           user_id,
           username,
           gender,
           zipcode,
           birthdate,
           headline,
           myidentity,
           approved,
           approved_on,
           laston,
           created_on,
           show_prefs,
           on_line,
           show,
           pict,
           showastro,
           zodiac_sign,
           height_cm,
           height_in,
           noshowdescrp,
           lat_rad,
           long_rad,
           attributes,
           backstage,
           pictimestamp,
           backstagetimestamp,
           video,
           languagesSpokenMask,
           profileLanguageMask,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId     
    FROM a_profile_dating
    WHERE user_id in (@id1,@id2,@id3,@id4,@id5,@id6,@id7,@id8,@id9,@id10,@id11,@id12)
    ORDER BY laston desc, user_id 
    AT ISOLATION READ UNCOMMITTED
   RETURN @@error
  END
 
 
 
 
go
GRANT EXECUTE ON dbo.wsp_getProfileByUserIdList12 TO web
go
IF OBJECT_ID('dbo.wsp_getProfileByUserIdList12') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileByUserIdList12 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileByUserIdList12 >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileByUserIdList12','unchained'
go
