IF OBJECT_ID('dbo.wsp_newUserInfoParty') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserInfoParty
    IF OBJECT_ID('dbo.wsp_newUserInfoParty') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserInfoParty >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserInfoParty >>>'  
END
go

CREATE PROCEDURE wsp_newUserInfoParty
 @userId             NUMERIC(12,0) 
,@username           VARCHAR(129)
,@user_type          CHAR(1)
,@password           VARCHAR(16)
,@gender             CHAR(1)
,@status             CHAR(1)
,@signuptime         INT
,@laston             INT
,@height_cm          TINYINT
,@birthdate          SMALLDATETIME
,@email              VARCHAR(129)
,@lat_rad            INT
,@long_rad           INT
,@zipcode            VARCHAR(10)
,@ethnic             CHAR(1)
,@religion           CHAR(1)
,@smoke              CHAR(1)
,@body_type          CHAR(1)
,@pref_last_on       CHAR(1)
,@preferred_units    CHAR(1)
,@signup_adcode      VARCHAR(30)
,@signup_context     CHAR(3)
,@user_agent         VARCHAR(80)
,@emailStatus        CHAR(1)
,@pref_clubll_signup CHAR(1)
,@languagesSpokenMask INT
,@countryId          SMALLINT
,@jurisdictionId     SMALLINT
,@secondJurisdictionId SMALLINT
,@cityId             INT
,@localePref             INT
,@signupLocalePref             INT
,@searchLanguageMask INT
AS
DECLARE @universalId NUMERIC(10,0)
,@randomNumber       INT
,@dateNow DATETIME
,@return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
	BEGIN
		RETURN @return
	END
EXEC wsp_UniversalId @universalId OUTPUT
EXEC wsp_RandomNumber @randomNumber OUTPUT,1000,9999 

BEGIN TRAN TRAN_newUserInfo

INSERT INTO dbo.user_info
(user_id
,username
,user_type
,password
,gender
,status
,signuptime
,laston
,height_cm
,birthdate
,email
,lat_rad
,long_rad
,zipcode
,ethnic
,religion
,smoke
,body_type
,pref_last_on
,preferred_units
,universal_id
,universal_password
,signup_adcode
,signup_context
,user_agent
,emailStatus
,pref_clubll_signup
,languagesSpokenMask
,countryId
,jurisdictionId
,secondJurisdictionId
,cityId
,localePref
,signupLocalePref
,searchLanguageMask
,dateModified
)
VALUES
(@userId
,LTRIM(UPPER(@username))
,@user_type
,LTRIM(UPPER(@password))
,@gender
,@status
,@signuptime
,@laston
,@height_cm
,@birthdate
,LTRIM(UPPER(@email))
,@lat_rad
,@long_rad
,LTRIM(UPPER(@zipcode))
,@ethnic
,@religion
,@smoke
,@body_type
,@pref_last_on
,@preferred_units
,@universalId
,@randomNumber
,@signup_adcode
,@signup_context
,@user_agent
,@emailStatus
,@pref_clubll_signup
,@languagesSpokenMask
,@countryId
,@jurisdictionId
,@secondJurisdictionId
,@cityId
,@localePref
,@signupLocalePref
,@searchLanguageMask
,@dateNow
)
	
IF @@error = 0
	BEGIN
   		COMMIT TRAN TRAN_newUserInfo
   		RETURN 0
  	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_newUserInfo
		RETURN 99
	END

go
IF OBJECT_ID('dbo.wsp_newUserInfoParty') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserInfoParty >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserInfoParty >>>'
go
EXEC sp_procxmode 'dbo.wsp_newUserInfoParty','unchained'
go
GRANT EXECUTE ON dbo.wsp_newUserInfoParty TO web
go



