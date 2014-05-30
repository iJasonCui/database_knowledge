IF OBJECT_ID('dbo.msp_getUserInfoByWapId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getUserInfoByWapId
    IF OBJECT_ID('dbo.msp_getUserInfoByWapId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getUserInfoByWapId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getUserInfoByWapId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Oct 2006
**   Description:  Retrieves user info for a given wapId
**
** REVISION(S):
**   Author: Mike Stairs 
**   Date:  Sept 16, 2008
**   Description: return email as well
**
*************************************************************************/

CREATE PROCEDURE  msp_getUserInfoByWapId
@wapId VARCHAR(128)
AS

BEGIN
SELECT user_id
    ,username
    ,password
    ,status
    ,WapInfo.userType
    ,gender
    ,birthdate
    ,height_cm
    ,zipcode
    ,lat_rad
    ,long_rad
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
WHERE wapId = @wapId 
AND user_info.user_id=WapInfo.userId

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.msp_getUserInfoByWapId TO web
go
IF OBJECT_ID('dbo.msp_getUserInfoByWapId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_getUserInfoByWapId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getUserInfoByWapId >>>'
go
EXEC sp_procxmode 'dbo.msp_getUserInfoByWapId','unchained'
go
