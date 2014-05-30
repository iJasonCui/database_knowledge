IF OBJECT_ID('dbo.wsp_getUserInfoByUniversalId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByUniversalId
    IF OBJECT_ID('dbo.wsp_getUserInfoByUniversalId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByUniversalId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByUniversalId >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Retrieves user info for a given universal id
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
**   Author: Yan L 
**   Date: November 30 2005
**   Description: add a few fake columns into the result to make web-900 purchase work. 
**
** REVISION(S):
**   Author: Yan L 
**   Date: December 8 2005
**   Description: remove those fake columns which are added for 900 purchase temp fix. 
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
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByUniversalId
@universalId NUMERIC(10,0)
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
FROM user_info
WHERE universal_id = @universalId

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoByUniversalId TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoByUniversalId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByUniversalId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByUniversalId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoByUniversalId','unchained'
go
