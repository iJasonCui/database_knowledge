IF OBJECT_ID('dbo.wsp_saveUserInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveUserInfo
    IF OBJECT_ID('dbo.wsp_saveUserInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveUserInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveUserInfo >>>'
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
**   Author:  Travis McCauley
**   Date:  August 5, 2004
**   Description:  Added signupLocalePref
**
**   Author:  Malay Dave
**   Date:  May 6, 2005
**   Description:  Added searchLanguageMask
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
**   Author: Yan L 
**   Date: December 2 2005
**   Description: fix the positional problem in this proc. 
**
**   Author: Andy Tran 
**   Date: Aug 2006
**   Description: Added signupIP 
**
******************************************************************************/
CREATE PROCEDURE wsp_saveUserInfo
@userId             NUMERIC(12,0) OUTPUT
,@user_id            NUMERIC(12,0)
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
,@user_agent         VARCHAR(80)
,@signup_context     CHAR(3)
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
        EXEC @RETURN = wsp_newUserInfo @userId OUTPUT
                            ,@username
                            ,@user_type
                            ,@password
                            ,@gender
                            ,@status
                            ,@signuptime
                            ,@laston
                            ,@height_cm
                            ,@birthdate
                            ,@email
                            ,@lat_rad
                            ,@long_rad
                            ,@zipcode
                            ,@ethnic
                            ,@religion
                            ,@smoke
                            ,@body_type
                            ,@pref_last_on
                            ,@preferred_units
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
                            ,@signupIP

    END
ELSE
    BEGIN
        EXEC @RETURN = wsp_updUserInfo @user_id
                            ,@username
                            ,@user_type
                            ,@password
                            ,@gender
                            ,@status
                            ,@signuptime
                            ,@laston
                            ,@height_cm
                            ,@birthdate
                            ,@email
                            ,@lat_rad
                            ,@long_rad
                            ,@zipcode
                            ,@ethnic
                            ,@religion
                            ,@smoke
                            ,@body_type
                            ,@pref_last_on
                            ,@preferred_units
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
                            ,@searchLanguageMask
        SELECT @userId = @user_id
    END

RETURN @RETURN
 
go
GRANT EXECUTE ON dbo.wsp_saveUserInfo TO web
go
IF OBJECT_ID('dbo.wsp_saveUserInfo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveUserInfo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveUserInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveUserInfo','unchained'
go
