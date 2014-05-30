IF OBJECT_ID('dbo.wssp_getProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getProfileByUserId
    IF OBJECT_ID('dbo.wssp_getProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getProfileByUserId >>>'
END
go
/***********************************************************************
 **   Author:  Frank Qi
 **   Date:  June 26, 2008
 **   Description:  Retrieves profile data for a given user id - online status
 **
 ** REVISION(S):
 **   Author:  Frank Qi
 **   Date:  July 2, 2008
 **   Description:  added birthdate,userId,headline,country,country_area,city, it is compatible 
*************************************************************************/

CREATE PROCEDURE  wssp_getProfileByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT   myidentity as nickname,
                  user_id as userId,
                  myidentity,
                  on_line,
                  birthdate,
                  country,
                  country_area as state,
                  city,
                  on_line as [online],
                  headline as [openingLine],
                  laston,
                  height_cm,
                  height_in,
                  body_type as bodyType,
                  ethnic as ethnicity,
                  smoke as smoking,
                  drink as drinking,
                  religion,
                  education,
                  zodiac_sign as zodiac,
                  income,
                  children as childrenHave,
                  child_plans as childPlans,
                  approved,
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
EXEC sp_procxmode 'dbo.wssp_getProfileByUserId','unchained'
go
IF OBJECT_ID('dbo.wssp_getProfileByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getProfileByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getProfileByUserId >>>'
go
GRANT EXECUTE ON dbo.wssp_getProfileByUserId TO web
go
