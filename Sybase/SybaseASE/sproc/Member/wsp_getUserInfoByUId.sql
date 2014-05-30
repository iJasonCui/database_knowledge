IF OBJECT_ID('dbo.wsp_getUserInfoByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoByUId
    IF OBJECT_ID('dbo.wsp_getUserInfoByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoByUId >>>'
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
**   Author: Yan Liu 
**   Date: April 6 2005
**   Description: added first pay time 
*************************************************************************/

CREATE PROCEDURE  wsp_getUserInfoByUId
    @userId NUMERIC(12, 0)
AS

BEGIN
    SELECT user_id,
           username,
           password,
           status,
           user_type,
           gender,
           birthdate,
           fname,
           lname,
           user_agent,
           city,
           country_area,
           country,
           zipcode,
           laston,
           signuptime,
           email,
           area,
           universal_id,
           universal_password,
           signup_context,
           body_type,
           ethnic,
           religion,
           smoke,
           height_cm,
           height_in,
           onhold_greeting,
           onhold_city,
           emailStatus,
           localePref,
           languagesSpokenMask,
           countryId,
           jurisdictionId,
           secondJurisdictionId,
           cityId,
           signup_adcode,
           firstpaytime 
      FROM user_info
     WHERE user_id = @userId

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getUserInfoByUId TO web
go

IF OBJECT_ID('dbo.wsp_getUserInfoByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoByUId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserInfoByUId','unchained'
go
