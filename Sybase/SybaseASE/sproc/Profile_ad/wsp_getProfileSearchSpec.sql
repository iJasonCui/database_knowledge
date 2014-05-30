IF OBJECT_ID('dbo.wsp_getProfileSearchSpec') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileSearchSpec
    IF OBJECT_ID('dbo.wsp_getProfileSearchSpec') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileSearchSpec >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileSearchSpec >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  July 4 2002  
**   Description:  retrieves profile by nickname if type=N or memberId if type=M
**
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
******************************************************************************/

CREATE PROCEDURE wsp_getProfileSearchSpec
 @productCode CHAR(1)
,@communityCode CHAR(1)
,@myidentity VARCHAR(16)
AS
BEGIN
	SELECT 
           a_profile_dating.user_id,
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
           interest1,
           interest2,
           interest3,
           utext,
           video,
           languagesSpokenMask,
           profileLanguageMask,
           profileLanguage,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId
	FROM a_profile_dating, a_dating
	WHERE myidentity = @myidentity
	AND a_profile_dating.user_id = a_dating.user_id
	AND show = 'Y' AND (show_prefs = 'Y' OR (show_prefs = 'O' AND on_line = 'Y'))
	AT ISOLATION READ UNCOMMITTED	

    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getProfileSearchSpec TO web
go
IF OBJECT_ID('dbo.wsp_getProfileSearchSpec') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileSearchSpec >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileSearchSpec >>>'
go
EXEC sp_procxmode 'dbo.wsp_getProfileSearchSpec','unchained'
go
