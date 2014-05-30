IF OBJECT_ID('dbo.msp_getProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getProfileByUserId
    IF OBJECT_ID('dbo.msp_getProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getProfileByUserId >>>'
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
*************************************************************************/

CREATE PROCEDURE  msp_getProfileByUserId
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
                  sportsParticipate
	FROM   a_profile_dating
	WHERE  user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.msp_getProfileByUserId TO web
go
IF OBJECT_ID('dbo.msp_getProfileByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_getProfileByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getProfileByUserId >>>'
go
EXEC sp_procxmode 'dbo.msp_getProfileByUserId','unchained'
go
