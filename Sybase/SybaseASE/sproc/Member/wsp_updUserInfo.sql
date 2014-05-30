IF OBJECT_ID('dbo.wsp_updUserInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfo
    IF OBJECT_ID('dbo.wsp_updUserInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfo >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 10 2002
**   Description:  Updates row in user_info
**
** REVISION(S):
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
**   Description:   Removed UPPER for City
**
**   Author:  Malay Dave
**   Date:  May 6 2005
**   Description:   Added searchLanguageMask
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
**   Author: Yan L 
**   Date: December 2 2005
**   Description: fix input parameter mismatch problem. 
**
**   Author: Andy Tran
**   Date: Jul 30 2008
**   Description: use email address as username
**
******************************************************************************/
CREATE PROCEDURE wsp_updUserInfo
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
,@searchLanguageMask INT
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

BEGIN TRAN TRAN_updUserInfo

UPDATE dbo.user_info SET
 username=LTRIM(UPPER(@username))
,user_type=@user_type
,password=LTRIM(UPPER(@password))
,gender=@gender
,status=@status
,signuptime=@signuptime
,laston=@laston
,height_cm=@height_cm
,birthdate=@birthdate
,email=LTRIM(UPPER(@email))
,lat_rad=@lat_rad
,long_rad=@long_rad
,lat_rad1=@lat_rad1
,long_rad1=@long_rad1
,zipcode=LTRIM(UPPER(@zipcode))
,ethnic=@ethnic
,religion=@religion
,smoke=@smoke
,body_type=@body_type
,pref_last_on=@pref_last_on
,preferred_units=@preferred_units
,signup_adcode=@signup_adcode
,signup_context=@signup_context
,user_agent=@user_agent
,emailStatus=@emailStatus
,pref_clubll_signup=@pref_clubll_signup
,languagesSpokenMask=@languagesSpokenMask
,countryId=@countryId
,jurisdictionId=@jurisdictionId
,secondJurisdictionId=@secondJurisdictionId
,cityId=@cityId
,searchLanguageMask=@searchLanguageMask
,dateModified=@dateNow
WHERE user_id = @userId

IF @@error = 0
	BEGIN
  		COMMIT TRAN TRAN_updUserInfo
    	RETURN 0
  	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_updUserInfo
		RETURN 99
	END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfo TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfo >>>'
go
--EXEC sp_procxmode 'dbo.wsp_updUserInfo','unchained'
--go
