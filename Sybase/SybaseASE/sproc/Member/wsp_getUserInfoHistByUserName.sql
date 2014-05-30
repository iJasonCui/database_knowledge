IF OBJECT_ID('dbo.wsp_getUserInfoHistByUserName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoHistByUserName
    IF OBJECT_ID('dbo.wsp_getUserInfoHistByUserName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoHistByUserName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoHistByUserName >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  August 30 2002
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
**   Author: Andy Tran
**   Date: Jul 30 2008
**   Description: use email address as username
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoHistByUserName
 @username VARCHAR(129)
AS
SELECT @username = UPPER(@username)

BEGIN
    IF NOT EXISTS (SELECT 1 FROM user_info WHERE username = @username)
        BEGIN
            SELECT @username = username FROM user_info WHERE email = @username
        END 

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
     WHERE username = @username

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getUserInfoHistByUserName TO web
go

IF OBJECT_ID('dbo.wsp_getUserInfoHistByUserName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoHistByUserName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoHistByUserName >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserInfoHistByUserName','unchained'
go
