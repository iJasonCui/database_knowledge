USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_getProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getProfileByUserId
    IF OBJECT_ID('dbo.wsp_getProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getProfileByUserId >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6, 2002
**   Description:  Retrieves profile data for a given user id
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 12, 2004
**   Description: added openingLineLanguage  & languagesSpokenMask
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
**   Author: Yadira Genoves
**   Date: August 2009
**   Description: profileFeatures - column added
*************************************************************************/

CREATE PROCEDURE  wsp_getProfileByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT myidentity,
                  approved,
                  headline,
                  show_prefs,
                  showastro,
                  attributes,
                  approved_on,
                  created_on,
                  outdoors,
                  sportsWatch,
                  entertainment,
                  hobbies,
                  pict,
                  backstage,
                  pictimestamp,
                  backstagetimestamp,
                  gender,
                  openingLineLanguage,
                  languagesSpokenMask,
                  profileLanguageMask,
                  countryId,
                  jurisdictionId,
                  secondJurisdictionId,
                  cityId,
                  sportsParticipate,
                  ISNULL(profileFeatures, 0) as profileFeatures
	FROM   a_profile_dating
	WHERE  user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getProfileByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_getProfileByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getProfileByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getProfileByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_getProfileByUserId TO web
go
