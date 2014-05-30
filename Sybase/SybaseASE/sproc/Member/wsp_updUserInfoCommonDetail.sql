IF OBJECT_ID('dbo.wsp_updUserInfoCommonDetail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoCommonDetail
    IF OBJECT_ID('dbo.wsp_updUserInfoCommonDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoCommonDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoCommonDetail >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  Oct. 20 2002
**   Description:  Updates common row on profile(after creating a new profile)
**
** REVISION(S):
**   Author: Valeri Popov
**   Date: Apr. 14, 2004
**   Description: Added languagesSpokenMask
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: eliminated references to removed columns from user_info
**
*************************************************************************/

CREATE PROCEDURE  wsp_updUserInfoCommonDetail
 @userId        NUMERIC(12,0)
,@body_type     CHAR(1)
,@ethnic        CHAR(1)
,@religion      CHAR(1)
,@smoke         CHAR(1)
,@height_cm     tinyint
,@gender        CHAR(1)
,@birthdate     SMALLDATETIME
,@lat_rad       INT
,@long_rad      INT
,@zipcode       VARCHAR(10)
,@languagesSpokenMask INT
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int

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

BEGIN TRAN TRAN_updUserInfoCommonDetail
     UPDATE user_info SET
	     body_type=@body_type,
	     ethnic=@ethnic,
	     religion=@religion,
	     smoke=@smoke,
	      height_cm=@height_cm,
              gender=@gender,
              birthdate=@birthdate,
              lat_rad=@lat_rad,
              long_rad=@long_rad,
              lat_rad1=@lat_rad1,
              long_rad1=@long_rad1,
              zipcode=@zipcode,
              languagesSpokenMask=@languagesSpokenMask,
              countryId=@countryId,
              jurisdictionId=@jurisdictionId,
              secondJurisdictionId=@secondJurisdictionId,
              cityId=@cityId,
              dateModified=@dateNow

     WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoCommonDetail
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoCommonDetail
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoCommonDetail TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoCommonDetail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoCommonDetail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoCommonDetail >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoCommonDetail','unchained'
go
