IF OBJECT_ID('dbo.msp_getUserInfoByUserNameWap') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getUserInfoByUserNameWap
    IF OBJECT_ID('dbo.msp_getUserInfoByUserNameWap') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getUserInfoByUserNameWap >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getUserInfoByUserNameWap >>>'
END
go
 
/***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Oct 2006
**   Description:  Retrieves user info for a given userName/password
**
** REVISION(S):
**   Author: Mike Stairs 
**   Date:  Sept 16, 2008
**   Description: return username and email as well
**
*************************************************************************/

CREATE PROCEDURE dbo.msp_getUserInfoByUserNameWap
 @userName VARCHAR(129)
,@password VARCHAR(16)
AS

BEGIN
SELECT user_id
    ,username
    ,status
    ,WapInfo.userType
    ,gender
    ,birthdate
    ,height_cm
    ,zipcode
    ,long_rad
    ,lat_rad
    ,preferred_units
    ,body_type
    ,ethnic
    ,religion
    ,smoke
    ,onhold_greeting
    ,countryId
    ,jurisdictionId
    ,secondJurisdictionId
    ,cityId
    ,mobileNumber
    ,WapInfo.dateModified
    ,email
	FROM user_info,WapInfo
	WHERE (username = @userName or email = @userName) 
	AND password = @password
        AND user_info.user_id*=WapInfo.userId

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.msp_getUserInfoByUserNameWap TO web
go
IF OBJECT_ID('dbo.msp_getUserInfoByUserNameWap') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_getUserInfoByUserNameWap >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getUserInfoByUserNameWap >>>'
go
EXEC sp_procxmode 'dbo.msp_getUserInfoByUserNameWap','unchained'
go
