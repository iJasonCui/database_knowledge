IF OBJECT_ID('dbo.wsp_getUserInfoByEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByEmail
    IF OBJECT_ID('dbo.wsp_getUserInfoByEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByEmail >>>'
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
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByEmail
@email VARCHAR(129)
AS
SELECT @email = UPPER(@email)

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
WHERE email = @email
AND user_type NOT IN ('S','A','D','B')

RETURN @@error
END
 
 

go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByEmail','unchained'
go
IF OBJECT_ID('dbo.wsp_getUserInfoByEmail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByEmail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByEmail >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByEmail TO web
go
