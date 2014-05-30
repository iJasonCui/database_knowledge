IF OBJECT_ID('dbo.wsp_newUserInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserInfo
    IF OBJECT_ID('dbo.wsp_newUserInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserInfo >>>'
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
**   Author:  Travis McCauley
**   Date:  August 5, 2004
**   Description:  Added signupLocalePref
**
**   Author:  Malay Dave
**   Date:  May 6 2005
**   Description:  Added searchLanguageMask
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
**   Author: Andy Tran
**   Date: Aug 2006
**   Description: Added signupIP
**
**   Author: Andy Tran
**   Date: Jul 30 2008
**   Description: use email address as username
**
******************************************************************************/
CREATE PROCEDURE wsp_newUserInfo
 @userId             NUMERIC(12,0) OUTPUT
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
,@localePref         INT
,@signupLocalePref   INT
,@searchLanguageMask INT
,@signupIP           NUMERIC(12,0)
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

EXEC wsp_UserId @userId OUTPUT
EXEC wsp_UniversalId @universalId OUTPUT
EXEC wsp_RandomNumber @randomNumber OUTPUT,1000,9999 
DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT
DECLARE @maxUserCellId SMALLINT
SELECT @maxUserCellId = maxUserCellId FROM UserCellId

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
,lat_rad1
,long_rad1
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
,signupIP
,userCellId
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
,@lat_rad1
,@long_rad1
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
,@signupIP
,(@userId % @maxUserCellId + 1)
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
IF OBJECT_ID('dbo.wsp_newUserInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_newUserInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_newUserInfo TO web
go
