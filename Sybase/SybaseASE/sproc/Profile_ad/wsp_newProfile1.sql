IF OBJECT_ID('dbo.wsp_newProfile1') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newProfile1
    IF OBJECT_ID('dbo.wsp_newProfile1') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newProfile1 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newProfile1 >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Inserts row into profile
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
**   Description: added profileLanguageMask
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: removed reference to location_id and showastro
**
*************************************************************************/

CREATE PROCEDURE wsp_newProfile1
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
,@profileLanguageMask int

AS

DECLARE @lat_rad1 int, @long_rad1 int
EXEC wsp_getLatLong @lat_rad, @long_rad, @countryId, @cityId, @lat_rad1 OUTPUT, @long_rad1 OUTPUT


BEGIN TRAN TRAN_newProfile1
     
     INSERT INTO a_profile_dating (
              height_cm,
		      height_in,
		      birthdate,
		      country,
		      country_area,
		      city,
		      lat_rad,
		      long_rad,
		      lat_rad1,
		      long_rad1,
		      zipcode,
		      attributes,
		      user_id,
		      gender,
		      user_type,
		      myidentity,
		      headline,
		      created_on,
		      approved_on,
		      username,
	              show_prefs,
		      approved,
		      show,
		      noshowdescrp,
              on_line,
              laston,
              signup_adcode,
              zodiac_sign,
	      languagesSpokenMask,
	      openingLineLanguage,
                     countryId,
            jurisdictionId,
            secondJurisdictionId,
            cityId,
            profileLanguageMask

              )
              VALUES (
		      @height_cm,
		      @height_in,
		      @birthdate,
		      @country,
		      @country_area,
		      @city,
		      @lat_rad,
		      @long_rad,
		      @lat_rad1,
		      @long_rad1,
		      @zipcode,
		      @attributes,
		      @userId,
		      @gender,
		      @user_type,
		      @myidentity,
		      @headline,
		      @created_on,
		      @approved_on,
		      @username,
		      @show_prefs,
		      @approved,
		      @show,
		      @noshowdescrp,
              @on_line,
              @laston,
              @signup_adcode,
              @zodiac_sign,
	      @languagesSpokenMask,

            @openingLineLanguage,
            @countryId,
            @jurisdictionId,
            @secondJurisdictionId,
            @cityId,
            @profileLanguageMask
              )
    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newProfile1
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newProfile1
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_newProfile1 TO web
go
IF OBJECT_ID('dbo.wsp_newProfile1') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newProfile1 >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newProfile1 >>>'
go
EXEC sp_procxmode 'dbo.wsp_newProfile1','unchained'
go
