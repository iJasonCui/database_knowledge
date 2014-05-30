IF OBJECT_ID('dbo.wsp_saveUserInfoReg') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveUserInfoReg
    IF OBJECT_ID('dbo.wsp_saveUserInfoReg') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveUserInfoReg >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveUserInfoReg >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 10 2002
**   Description:  Inserts/Updates row in user_info and web900create
**
** REVISION(S):  
**   Author:  Jack Veiga/Francisc Schnoberger
**   Date:  October 8 2002
**   Description:  Add return codes for duplicate username/email
**
**   Author:  Malay Dave
**   Date:  Mar 4 2004
**   Description:  Add new col 'pref_clubll_signup' - for storing clubll signup preference
**
**   Author:  Valeri Popov
**   Date:  Apr. 16 2004
**   Description:  Add languagesSpokenMask, countryId, jurisdictionId, secondJursidictionId,
**                 cityId
**
**   Author:  Travis McCauley
**   Date:  July 19, 2004
**   Description:  Added localePref
**
******************************************************************************/
CREATE PROCEDURE wsp_saveUserInfoReg
 



@userId             NUMERIC(12,0) OUTPUT
,@user_id            NUMERIC(12,0)
,@username           VARCHAR(129)
,@user_type          CHAR(1)
,@tid                VARCHAR(14)
,@password           VARCHAR(16)
,@gender             CHAR(1)
,@status             CHAR(1)
,@signuptime         INT
,@laston             INT
,@height_cm          TINYINT
,@height_in          TINYINT
,@birthdate          SMALLDATETIME
,@zodiac_sign        CHAR(1)
,@email              VARCHAR(129)
,@email_real         VARCHAR(129)
,@city               VARCHAR(24)
,@country            VARCHAR(24)
,@country_area       VARCHAR(32)
,@lat_rad            INT
,@long_rad           INT
,@location_id        NUMERIC(12,0)
,@zipcode            VARCHAR(10)
,@ethnic             CHAR(1)
,@religion           CHAR(1)
,@smoke              CHAR(1)
,@body_type          CHAR(1)
,@search_checkbox    CHAR(1)
,@pref_last_on       CHAR(1)
,@preferred_units    CHAR(1)
,@pref_email_news    CHAR(1)
,@pref_email_newmail CHAR(1)
,@pref_partner_new   CHAR(1)
,@timezone           VARCHAR(10)
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
AS
DECLARE @RETURN INT
SELECT @RETURN = 0

IF EXISTS (SELECT 1 FROM user_info WHERE status != 'J' AND user_id != @user_id AND username = @username AND user_type in ('F','P'))
	BEGIN
		SELECT @RETURN = @RETURN + 1
	END

IF EXISTS (SELECT 1 FROM user_info WHERE status != 'J' AND user_id != @user_id AND email = @email AND user_type in ('F','P'))
	BEGIN
		SELECT @RETURN = @RETURN + 2
	END

IF @RETURN != 0
	BEGIN
		RETURN @RETURN
	END
ELSE

  IF @user_id = 0
    BEGIN
        EXEC @RETURN = wsp_newUserInfoReg @userId OUTPUT
                            ,@username
                            ,@user_type
                            ,@tid
                            ,@password
                            ,@gender
                            ,@status
                            ,@signuptime
                            ,@laston
                            ,@height_cm
                            ,@height_in
                            ,@birthdate
                            ,@zodiac_sign
                            ,@email
                            ,@email_real
                            ,@city
                            ,@country
                            ,@country_area
                            ,@lat_rad
                            ,@long_rad
                            ,@location_id
                            ,@zipcode
                            ,@ethnic
                            ,@religion
                            ,@smoke
                            ,@body_type
                            ,@search_checkbox
                            ,@pref_last_on
                            ,@preferred_units
                            ,@pref_email_news
                            ,@pref_email_newmail
                            ,@pref_partner_new
                            ,@timezone
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

    END
ELSE
    BEGIN
        EXEC @RETURN = wsp_updUserInfo @user_id
                            ,@username
                            ,@user_type
                            ,@tid
                            ,@password
                            ,@gender
                            ,@status
                            ,@signuptime
                            ,@laston
                            ,@height_cm
                            ,@height_in
                            ,@birthdate
                            ,@zodiac_sign
                            ,@email
                            ,@email_real
                            ,@city
                            ,@country
                            ,@country_area
                            ,@lat_rad
                            ,@long_rad
                            ,@location_id
                            ,@zipcode
                            ,@ethnic
                            ,@religion
                            ,@smoke
                            ,@body_type
                            ,@search_checkbox
                            ,@pref_last_on
                            ,@preferred_units
                            ,@pref_email_news
                            ,@pref_email_newmail
                            ,@pref_partner_new
                            ,@timezone
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
        SELECT @userId = @user_id
    END

RETURN @RETURN
 
go
GRANT EXECUTE ON dbo.wsp_saveUserInfoReg TO web
go
IF OBJECT_ID('dbo.wsp_saveUserInfoReg') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveUserInfoReg >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveUserInfoReg >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveUserInfoReg','unchained'
go
