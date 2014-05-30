IF OBJECT_ID('dbo.wsp_getUserInfoByWapId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByWapId
    IF OBJECT_ID('dbo.wsp_getUserInfoByWapId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByWapId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByWapId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Oct 2006
**   Description:  Retrieves user info for a given wapId
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByWapId
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
FROM user_info,WapInfo
WHERE wapId = @wapId 
AND user_info.user_id=WapInfo.userId

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByWapId TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByWapId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByWapId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByWapId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByWapId','unchained'
go
