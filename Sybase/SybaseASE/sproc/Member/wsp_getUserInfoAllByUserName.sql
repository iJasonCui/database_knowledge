IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoAllByUserName
    IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoAllByUserName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoAllByUserName >>>'
END
go
 
/***********************************************************************
**
** CREATION:
**   Author:       Mark Jaeckle
**   Date:         September 12, 2002
**   Description:  Retrieves user info for a given userName/password
**
** REVISION(S):
**   Author:       Malay Dave
**   Date:         Mar 4 2004
**   Description:  Add new col 'pref_clubll_signup' - for storing clubll signup preference
**
**   Author:       Mike Stairs
**   Date:         Oct 2005
**   Description:  eliminated references to removed columns from user_info
**
**   Author:       Andy Tran
**   Date:         Feb 2007
**   Description:  always returns 'N' for mail preferences (collect call not accecpted)
**
**   Author:       Andy Tran
**   Date:         Jul 30 2008
**   Description:  use email address as username
**
**   Author:       Sean Dwyer
**   Date:         Dec 2008
**   Description:  added messageOnHoldStatus
*************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserInfoAllByUserName
 @userName VARCHAR(129)
,@password VARCHAR(16)
AS

BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_info WHERE username = @userName AND password = @password)
        BEGIN
            SELECT @userName = username FROM user_info WHERE email = @userName AND password = @password
        END 

    SELECT user_id
          ,status
          ,user_type
          ,email
          ,gender
          ,laston
          ,birthdate
          ,height_cm
          ,zipcode
          ,long_rad
          ,lat_rad
          ,preferred_units
          ,pref_last_on
          ,'N' --mail_dating
          ,'N' --mail_romance
          ,'N' --mail_intimate
          ,acceptnotify
          ,body_type
          ,smoke
          ,ethnic
          ,religion
          ,signup_adcode
          ,signup_context
          ,onhold_greeting
          ,last_logoff
          ,emailStatus
          ,signuptime
          ,pref_clubll_signup
          ,localePref 
          ,languagesSpokenMask
          ,countryId
          ,jurisdictionId
          ,secondJurisdictionId
          ,cityId
          ,searchLanguageMask
          ,ISNULL(pref_community_checkbox,'MMM')
          ,ISNULL(mediaReleaseFlag,'Y')
          ,signupIP
          ,username
          ,messageOnHoldStatus
      FROM user_info
     WHERE username = @userName 
       AND password = @password

    RETURN @@error
END

 

go
EXEC sp_procxmode 'dbo.wsp_getUserInfoAllByUserName','unchained'
go
IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserName') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoAllByUserName >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoAllByUserName >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserInfoAllByUserName TO web
go
