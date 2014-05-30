IF OBJECT_ID('dbo.wsp_getUserInfoHistByEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoHistByEmail
    IF OBJECT_ID('dbo.wsp_getUserInfoHistByEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoHistByEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoHistByEmail >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  August 27 2002
**   Description:  Retrieves user info hist for a given user id
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

CREATE PROCEDURE  wsp_getUserInfoHistByEmail
@email VARCHAR(129)
AS
SELECT @email = UPPER(@email)

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
WHERE email = @email

RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoHistByEmail TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoHistByEmail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoHistByEmail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoHistByEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoHistByEmail','unchained'
go
