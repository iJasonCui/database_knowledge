IF OBJECT_ID('dbo.wsp_newUserInfoReg') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserInfoReg
    IF OBJECT_ID('dbo.wsp_newUserInfoReg') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserInfoReg >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserInfoReg >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang 
**   Date:  June 9 2002  
**   Description:  Inserts row in user_info and web900create  
**
** REVISION(S):
**   Author: Jack Veiga
**   Date: August 2003
**   Description: Eliminated insert to web900create
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
**   Author:  Valeri Popov
**   Date:  May 4 2004
**   Description:  Removed UPPER for City
**
**   Author:  Travis McCauley
**   Date:  July 19, 2004
**   Description:  Added localePref
**
**   Author: Andy Tran
**   Date: Jul 30 2008
**   Description: use email address as username
**
******************************************************************************/
CREATE PROCEDURE wsp_newUserInfoReg
 @userId             NUMERIC(12,0) OUTPUT
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
DECLARE @universalId NUMERIC(10,0)
,@randomNumber       INT

EXEC wsp_UserId @userId OUTPUT
EXEC wsp_UniversalId @universalId OUTPUT
EXEC wsp_RandomNumber @randomNumber OUTPUT,1000,9999 
DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT


BEGIN TRAN TRAN_newUserInfo

INSERT INTO dbo.user_info
(user_id
,username
,user_type
,tid
,password
,gender
,status
,signuptime
,laston
,height_cm
,height_in
,birthdate
,zodiac_sign
,email
,email_real
,city
,country
,country_area
,lat_rad
,long_rad
,lat_rad1
,long_rad1
,location_id
,zipcode
,ethnic
,religion
,smoke
,body_type
,search_checkbox
,pref_last_on
,preferred_units
,pref_email_news
,pref_email_newmail
,pref_partner_new
,timezone
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
)
VALUES
(@userId
,LTRIM(UPPER(@username))
,@user_type
,@tid
,LTRIM(UPPER(@password))
,@gender
,@status
,@signuptime
,@laston
,@height_cm
,@height_in
,@birthdate
,@zodiac_sign
,LTRIM(UPPER(@email))
,@email_real
,@city
,@country
,@country_area
,@lat_rad
,@long_rad
,@lat_rad1
,@long_rad1
,@location_id
,LTRIM(UPPER(@zipcode))
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
GRANT EXECUTE ON dbo.wsp_newUserInfoReg TO web
go
IF OBJECT_ID('dbo.wsp_newUserInfoReg') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserInfoReg >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserInfoReg >>>'
go
EXEC sp_procxmode 'dbo.wsp_newUserInfoReg','unchained'
go
