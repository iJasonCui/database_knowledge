IF OBJECT_ID('dbo.wsp_updUserInfoByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update user info by user id
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 28, 2004
**   Description: added new Location code
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
**   Author: Andy Tran
**   Date: May 2010
**   Description: added preferred_units
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoByUserId
 @userId               numeric(12,0)
,@height_cm            tinyint
,@body_type            char(1)
,@ethnic               char(1)
,@religion             char(1)
,@smoking              char(1)
,@birthdate            smalldatetime
,@lat_rad              int
,@long_rad             int
,@zipcode              varchar(10)
,@countryId            smallint
,@jurisdictionId       smallint
,@secondJurisdictionId smallint
,@cityId               int
,@preferred_units      char(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END


DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT

BEGIN TRAN TRAN_updUserInfoByUserId
    UPDATE user_info
       SET birthdate = @birthdate
          ,zipcode = @zipcode
          ,lat_rad = @lat_rad
          ,long_rad = @long_rad
          ,lat_rad1 = @lat_rad1
          ,long_rad1 = @long_rad1
          ,height_cm = @height_cm
          ,smoke = @smoking
          ,body_type = @body_type
          ,ethnic = @ethnic
          ,religion = @religion
          ,countryId = @countryId
          ,jurisdictionId = @jurisdictionId
          ,secondJurisdictionId = @secondJurisdictionId
          ,cityId = @cityId
          ,preferred_units = @preferred_units
          ,dateModified = @dateNow
     WHERE user_id = @userId

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoByUserId
            RETURN 99
        END

    COMMIT TRAN TRAN_updUserInfoByUserId
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_updUserInfoByUserId TO web
go

IF OBJECT_ID('dbo.wsp_updUserInfoByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_updUserInfoByUserId','unchained'
go
