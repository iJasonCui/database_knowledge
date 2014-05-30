IF OBJECT_ID('dbo.wssp_getFullProfileByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wssp_getFullProfileByUserId
    IF OBJECT_ID('dbo.wssp_getFullProfileByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wssp_getFullProfileByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wssp_getFullProfileByUserId >>>'
END
go

CREATE PROCEDURE  wssp_getFullProfileByUserId
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
AS

BEGIN
	SELECT   user_id as userId,
             myidentity as nickname,
             on_line as [online],             
             laston,   
             gender,             
             headline as [openingLine],                       
             birthdate,
             height_cm,
             height_in,
             countryId,
             jurisdictionId,
             secondJurisdictionId,
             cityId,             
             zipcode,
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
             outdoors,
             sportsWatch,
             entertainment,
             hobbies,
             sportsParticipate
	FROM   a_profile_dating
	WHERE  user_id = @userId
	AT ISOLATION READ UNCOMMITTED

	RETURN @@error
END

go
IF OBJECT_ID('dbo.wssp_getFullProfileByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wssp_getFullProfileByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wssp_getFullProfileByUserId >>>'
go
EXEC sp_procxmode 'dbo.wssp_getFullProfileByUserId','unchained'
go
GRANT EXECUTE ON dbo.wssp_getFullProfileByUserId TO web
go
