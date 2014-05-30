IF OBJECT_ID('dbo.wsp_getUserInfoByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByUserId
    IF OBJECT_ID('dbo.wsp_getUserInfoByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByUserId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Retrieves user info for a given user id
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 27, 2004
**   Description: added new location staff
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: May 2006
**   Description: added searchLanguageMask
**
**   Author: Mike Stairs
**   Date: July 2006
**   Description: return default signup_context if null
**
**   Author: Andy Tran
**   Date: Aug 2006
**   Description: added signupIP
**
**   Author: Sean Dwyer
**   Date: Dec 2008
**   Description: added messageOnHoldStatus
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByUserId
@userId NUMERIC(12,0)
AS

BEGIN
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
    ,messageOnHoldStatus
FROM user_info
WHERE user_id = @userId

RETURN @@error
END
 
 

go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByUserId','unchained'
go
IF OBJECT_ID('dbo.wsp_getUserInfoByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByUserId >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByUserId TO web
go
