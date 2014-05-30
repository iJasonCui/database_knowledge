IF OBJECT_ID('dbo.wsp_saveProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveProfile
    IF OBJECT_ID('dbo.wsp_saveProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveProfile >>>'
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
**   Description: added profileLanguageMask - update only if new profile
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 2005
**   Description: removed reference to location_id and showastro
**
*************************************************************************/

CREATE PROCEDURE wsp_saveProfile
@productCode char(1)
,@communityCode char(1)
,@userId numeric (12,0)
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
DECLARE @RETURN INT

IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id != @userId AND myidentity = @myidentity)
	BEGIN
		SELECT @RETURN = 1
	END
ELSE

  IF NOT EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id = @userId)
    BEGIN
        EXEC @RETURN = wsp_newProfile1   @userId
                            ,@height_cm
                            ,@height_in
                            ,@birthdate
                            ,@country
                            ,@country_area
                            ,@city
                            ,@lat_rad
                            ,@long_rad
                            ,@zipcode
                            ,@attributes
                            ,@iscouple
                            ,@gender
                            ,@user_type
                            ,@myidentity
                            ,@headline
                            ,@created_on
                            ,@approved_on
                            ,@username
                            ,@show_prefs
                            ,@approved
                            ,@show
                            ,@noshowdescrp
                            ,@on_line
                            ,@laston
                            ,@signup_adcode
                            ,@zodiac_sign
                           ,@languagesSpokenMask
                           ,@openingLineLanguage
                           ,@countryId 
                           ,@jurisdictionId 
                           ,@secondJurisdictionId 
                           ,@cityId
                           ,@profileLanguageMask 

    END
  ELSE
    BEGIN
        EXEC @RETURN = wsp_updProfile   @userId
                            ,@height_cm
                            ,@height_in
                            ,@birthdate
                            ,@country
                            ,@country_area
                            ,@city
                            ,@lat_rad
                            ,@long_rad
                            ,@zipcode
                            ,@attributes
                            ,@iscouple
                            ,@gender
                            ,@user_type
                            ,@myidentity
                            ,@headline
                            ,@created_on
                            ,@approved_on
                            ,@username
                            ,@show_prefs
                            ,@approved
                            ,@show
                            ,@noshowdescrp
                            ,@on_line
                            ,@laston
                            ,@signup_adcode
                            ,@zodiac_sign
                           ,@languagesSpokenMask
                           ,@openingLineLanguage
                           ,@countryId 
                           ,@jurisdictionId 
                           ,@secondJurisdictionId 
                           ,@cityId 
    END
RETURN @RETURN
 
go
GRANT EXECUTE ON dbo.wsp_saveProfile TO web
go
IF OBJECT_ID('dbo.wsp_saveProfile') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveProfile >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveProfile >>>'
go
EXEC sp_procxmode 'dbo.wsp_saveProfile','unchained'
go
