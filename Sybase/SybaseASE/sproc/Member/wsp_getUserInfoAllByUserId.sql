IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserInfoAllByUserId
    IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserInfoAllByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserInfoAllByUserId >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:        Jack Veiga
**   Date:          June 6, 2002
**   Description:   Retrieves user info for a given user id
**
** REVISION(S):
**   Author:        Andy Tran
**   Date:          July 6, 2004
**   Description:   Added localePref
**
** REVISION(S):
**   Author:        Yan L
**   Date:          Auguest 13, 2004
**   Description:   Add city 
**
*************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserInfoAllByUserId
@userId NUMERIC(12,0)
AS
BEGIN
    SELECT username 
          ,user_type
          ,email
          ,gender
          ,city
          ,country_area
          ,country
          ,zipcode
          ,location_id
          ,long_rad
          ,lat_rad
          ,timezone
          ,signup_adcode
          ,signup_context
          ,universal_id
          ,universal_password
          ,emailStatus
          ,localePref
          ,countryId
          ,jurisdictionId
          ,secondJurisdictionId
          ,cityId
          ,signuptime
    FROM user_info
    WHERE user_id = @userId
    RETURN @@error
END
 
go
GRANT EXECUTE ON dbo.wsp_getUserInfoAllByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getUserInfoAllByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserInfoAllByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserInfoAllByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserInfoAllByUserId','unchained'
go
