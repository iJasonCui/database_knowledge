IF OBJECT_ID('dbo.wsp_updProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfile
    IF OBJECT_ID('dbo.wsp_updProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfile >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 12 2002
**   Description:  Updates row on profile
**
** REVISION(S):
**   Author:  Valeri Popov
**   Date:  Apr. 16 2004
**   Description:  Add languagesSpokenMask & openingLineLanguage
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: eliminated individual attribute column updates
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: removed reference to location_id and showastro
**
*************************************************************************/

CREATE PROCEDURE wsp_updProfile
 @userId numeric (12,0)
,@height_cm int
,@height_in int
,@birthdate smalldatetime
,@country char(24)
,@country_area char(32)
,@city char(32)
,@lat_rad int
,@long_rad int
,@zipcode char(10)
,@attributes char(64)
,@iscouple char(1)
,@gender char(1)
,@user_type char(1)
,@myidentity char(16)
,@headline char(120)
,@created_on integer
,@approved_on integer
,@username char(16)
,@show_prefs char(1)
,@approved char(1)
,@show char(1)
,@noshowdescrp char(5)
,@on_line char(1)
,@laston int
,@signup_adcode varchar(30)
,@zodiac_sign char(1)
,@languagesSpokenMask INT
,@openingLineLanguage TINYINT
,@countryId smallint
,@jurisdictionId smallint
,@secondJurisdictionId smallint
,@cityId int

AS


DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT

BEGIN TRAN TRAN_updProfile
     UPDATE a_profile_dating SET
              height_cm=@height_cm,
		      height_in=@height_in,
		      birthdate=@birthdate,
		      country=@country,
		      country_area=@country_area,
		      city=@city,
		      lat_rad=@lat_rad,
		      long_rad=@long_rad,
		      lat_rad1=@lat_rad1,
		      long_rad1=@long_rad1,
		      zipcode=@zipcode,
		      attributes=@attributes,
		      gender=@gender,
		      user_type=@user_type,
		      myidentity=@myidentity,
		      headline=@headline,
		      created_on=@created_on,
		      approved_on=@approved_on,
		      username=@username,
		      show_prefs=@show_prefs,
		      approved=@approved,
		      show=@show,
		      noshowdescrp=@noshowdescrp,
              on_line=@on_line,
              laston=@laston,
              signup_adcode=@signup_adcode,
              zodiac_sign=@zodiac_sign,
	      languagesSpokenMask=@languagesSpokenMask,
	      openingLineLanguage=@openingLineLanguage,
                     countryId=@countryId,
            jurisdictionId=@jurisdictionId,
            secondJurisdictionId=@secondJurisdictionId,
            cityId=@cityId

    WHERE user_id=@userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfile
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfile
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfile TO web
go
IF OBJECT_ID('dbo.wsp_updProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfile','unchained'
go
