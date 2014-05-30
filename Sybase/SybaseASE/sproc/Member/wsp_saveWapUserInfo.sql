IF OBJECT_ID('dbo.wsp_saveWapUserInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveWapUserInfo
    IF OBJECT_ID('dbo.wsp_saveWapUserInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveWapUserInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveWapUserInfo >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 4 2006
**   Description:  saves/updates user_info  for wap account
**
*************************************************************************/

CREATE PROCEDURE wsp_saveWapUserInfo
@userId             NUMERIC(12,0) OUTPUT
,@user_id            NUMERIC(12,0)
,@username          VARCHAR(16)
,@password          VARCHAR(16)
,@gender            CHAR(1)
,@lat_rad           INT
,@long_rad          INT
,@zipcode           VARCHAR(10)
,@religion          CHAR(1)
,@height_cm         TINYINT
,@birthdate         SMALLDATETIME
,@body_type         CHAR(1)
,@ethnic            CHAR(1)
,@smoke             CHAR(1)
,@preferred_units   CHAR(1)
,@countryId         INT
,@jurisdictionId     INT
,@secondJurisdictionId INT
,@cityId             INT
,@localePref         INT

AS
DECLARE @date DATETIME
,@dateInt INT
,@previousUserId NUMERIC(12,0)
,@previousPid VARCHAR(64)
,@return INT
,@universalId NUMERIC(10,0)
,@randomNumber       INT

EXEC wsp_GetDateGMT @date OUTPUT

SELECT @dateInt = datediff(ss,"Jan 1 00:00 1970",@date)        

IF @user_id = 0
BEGIN
  EXEC wsp_UserId @userId OUTPUT
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
  ,firstidentitytime
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
  ,onhold_greeting
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
  )
  VALUES
  (@userId
  ,LTRIM(UPPER(@username))
  ,'F'
  ,LTRIM(UPPER(@password))
  ,@gender
  ,'A'
  ,@dateInt
  ,@dateInt
  ,@dateInt
  ,@height_cm
  ,@birthdate
  ,'NOBODY@LAVALIFE.COM'
  ,@lat_rad
  ,@long_rad
  ,LTRIM(UPPER(@zipcode))
  ,@ethnic
  ,@religion
  ,@smoke
  ,@body_type
  ,'Y'
  ,@preferred_units
  ,'N'
  ,@universalId
  ,@randomNumber
  ,'0'
  ,'anr'
  ,''
  ,'U'
  ,'N'
  ,1
  ,@countryId
  ,@jurisdictionId
  ,@secondJurisdictionId
  ,@cityId
  ,@localePref
  ,@localePref
  ,1
  ,@date
  ,0
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
END
ELSE
BEGIN  --  update existing account
   SELECT @userId = @user_id
   BEGIN TRAN TRAN_saveWapUserInfo

   UPDATE user_info SET
    user_id = @user_id
    ,zipcode = @zipcode
    ,countryId = @countryId
    ,jurisdictionId = @jurisdictionId
    ,secondJurisdictionId =@secondJurisdictionId
    ,cityId = @cityId
    ,religion = @religion
    ,height_cm = @height_cm
    ,body_type = @body_type
    ,ethnic = @ethnic
    ,smoke = @smoke
    ,dateModified = @date
   WHERE user_id = @userId

   IF @@error = 0
   BEGIN
	COMMIT TRAN TRAN_saveWapUserInfo
	RETURN 0
   END
   ELSE
   BEGIN
	ROLLBACK TRAN TRAN_saveWapUserInfo
	RETURN 99
   END
END
 
go
GRANT EXECUTE ON dbo.wsp_saveWapUserInfo TO web
go
IF OBJECT_ID('dbo.wsp_saveWapUserInfo') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveWapUserInfo >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveWapUserInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveWapUserInfo','unchained'
go
