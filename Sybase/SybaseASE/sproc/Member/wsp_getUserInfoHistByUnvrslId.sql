IF OBJECT_ID('dbo.wsp_getUserInfoHistByUnvrslId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoHistByUnvrslId
    IF OBJECT_ID('dbo.wsp_getUserInfoHistByUnvrslId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoHistByUnvrslId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoHistByUnvrslId >>>'
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
**   Description: hardcoded new language and city values to the default one
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info_hist
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoHistByUnvrslId
@universalId NUMERIC(10,0)
AS

BEGIN
SELECT user_id
    ,username
    ,password
    ,'J'
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
    ,signup_context
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
FROM user_info_hist
WHERE universal_id = @universalId

RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoHistByUnvrslId TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoHistByUnvrslId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoHistByUnvrslId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoHistByUnvrslId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoHistByUnvrslId','unchained'
go
