IF OBJECT_ID('dbo.wsp_getUserInfoByMobileNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByMobileNumber
    IF OBJECT_ID('dbo.wsp_getUserInfoByMobileNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByMobileNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByMobileNumber >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 2006
**   Description:  Retrieves user info for a given user id by mobile number
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByMobileNumber
@rowcount int
,@mobileNumber CHAR(10)
AS

BEGIN
SET ROWCOUNT @rowcount
SELECT user_id
    ,username
    ,password
    ,status
    ,user_type
    ,gender
    ,birthdate
    ,user_agent
    ,zipcode
    ,lat_rad
    ,long_rad
    ,laston
    ,signuptime
    ,email
    ,universal_id
    ,universal_password
    ,ISNULL(signup_context,'anr')
    ,body_type
    ,ethnic
    ,religion
    ,smoke
    ,height_cm
    ,onhold_greeting
    ,emailStatus
    ,countryId
    ,jurisdictionId
    ,secondJurisdictionId
    ,cityId
    ,localePref 
    ,languagesSpokenMask
    ,signup_adcode
    ,firstpaytime
    ,searchLanguageMask
    ,signupIP
FROM user_info,WapInfo
WHERE mobileNumber = @mobileNumber
      AND user_info.user_id=WapInfo.userId
AND user_type NOT IN ('S','A','D','B')

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByMobileNumber TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByMobileNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByMobileNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByMobileNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByMobileNumber','unchained'
go
