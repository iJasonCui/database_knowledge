IF OBJECT_ID('dbo.wsp_getUserInfoByUserNameWap') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByUserNameWap
    IF OBJECT_ID('dbo.wsp_getUserInfoByUserNameWap') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByUserNameWap >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByUserNameWap >>>'
END
go
 
/***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date:  Oct 2006
**   Description:  Retrieves user info for a given userName/password
**
*************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserInfoByUserNameWap
 @userName VARCHAR(16)
,@password VARCHAR(16)
AS

BEGIN
SELECT user_id
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
	FROM user_info,WapInfo
	WHERE username = @userName 
	AND password = @password
        AND user_info.user_id*=WapInfo.userId

	RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByUserNameWap TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByUserNameWap') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByUserNameWap >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByUserNameWap >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByUserNameWap','unchained'
go
