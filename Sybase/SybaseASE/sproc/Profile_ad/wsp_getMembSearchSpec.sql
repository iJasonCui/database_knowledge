USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_getMembSearchSpec') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMembSearchSpec
    IF OBJECT_ID('dbo.wsp_getMembSearchSpec') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMembSearchSpec >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMembSearchSpec >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves a_profile_dating by user_id or nickname
**
**          
** REVISION(S):
**   Author: Valeri Popov
**   Date: May 20, 2004
**   Description: Added new City columns
**
** REVISION(S): 
**   Author: Mike Stairs
**   Date: Aug 2004
**   Description: split sports into two columns
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column selects
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: eliminated location_id, and other unneeded columns
**
** REVISION(S):
**   Author: Yadira Genoves
**   Date: Feb 2006
**   Description: profileFeatures column added
******************************************************************************/
CREATE PROCEDURE  wsp_getMembSearchSpec
@productCode char(1),
@communityCode char(1),
@userId numeric(12,0),
@nickname varchar(16),
@targetUserId numeric(12,0)
AS
BEGIN
  IF @targetUserId > 0 
    BEGIN
      SELECT 
           a_profile_dating.user_id,
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
           interest1,
           interest2,
           interest3,
           utext,
           outdoors,
           sportsWatch,
           entertainment,
           hobbies,
           video,
           languagesSpokenMask,
           profileLanguageMask,
           profileLanguage,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId,
           sportsParticipate,
           gallery,
           gallerytimestamp,
           ISNULL(profileFeatures, 0) as profileFeatures
      FROM a_profile_dating,a_dating
      WHERE a_profile_dating.user_id=@targetUserId
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
                 AND initiator = 'N'
         )
      AND show_prefs between 'A' and 'Z'
      AND a_profile_dating.user_id=a_dating.user_id
      AT ISOLATION READ UNCOMMITTED
     RETURN @@error
    END
  ELSE
    BEGIN
      SELECT 
           a_profile_dating.user_id,
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
           interest1,
           interest2,
           interest3,
           utext,
           outdoors,
           sportsWatch,
           entertainment,
           hobbies,
	   video,
           languagesSpokenMask,
           profileLanguageMask,
           profileLanguage,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId,
           sportsParticipate,
           gallery,
           gallerytimestamp,
           ISNULL(profileFeatures, 0) as profileFeatures
      FROM a_profile_dating,a_dating
      WHERE myidentity=@nickname
         AND NOT EXISTS 
         (
              SELECT 
                   targetUserId 
              FROM Blocklist
              WHERE
                 userId=@userId 
                 AND targetUserId=a_profile_dating.user_id
                 AND initiator = 'N'
         )
      AND show_prefs between 'A' and 'Z'
      AND a_profile_dating.user_id=a_dating.user_id
      AT ISOLATION READ UNCOMMITTED
     RETURN @@error
    END
END
go
EXEC sp_procxmode 'dbo.wsp_getMembSearchSpec','unchained'
go
IF OBJECT_ID('dbo.wsp_getMembSearchSpec') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMembSearchSpec >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMembSearchSpec >>>'
go
GRANT EXECUTE ON dbo.wsp_getMembSearchSpec TO web
go
