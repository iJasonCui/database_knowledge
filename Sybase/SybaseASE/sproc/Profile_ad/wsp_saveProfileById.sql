USE Profile_ad
go
IF OBJECT_ID('dbo.wsp_saveProfileById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveProfileById
    IF OBJECT_ID('dbo.wsp_saveProfileById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveProfileById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveProfileById >>>'
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
** REVISION(S):
**   Author: Yadira Genoves
**   Date: August 2009
**   Description: profile's features column added
*************************************************************************/

CREATE PROCEDURE wsp_saveProfileById
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
,@openingLineLanguage tinyint
,@profileLanguageMask int
,@profileFeatures int

AS
DECLARE @RETURN INT

IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id != @userId AND myidentity = @myidentity)
    BEGIN
        SELECT @RETURN = 1
    END
ELSE
    BEGIN
        IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id = @userId)  --UPDATE
            BEGIN
                BEGIN TRAN TRAN_createProfile
                    UPDATE a_profile_dating
                    SET  height_cm=@height_cm
                        ,height_in=@height_in
                        ,birthdate=@birthdate
                        ,country=@country
                        ,country_area=@country_area
                        ,city=@city
                        ,lat_rad=@lat_rad
                        ,long_rad=@long_rad
                        ,zipcode=@zipcode
                        ,attributes=@attributes
                        ,gender=@gender
                        ,user_type=@user_type
                        ,myidentity=@myidentity
                        ,headline=@headline
                        ,created_on=@created_on
                        ,approved_on=@approved_on
                        ,username=@username
                        ,show_prefs=@show_prefs
                        ,approved=@approved
                        ,show=@show
                        ,noshowdescrp=@noshowdescrp
                        ,on_line=@on_line
                        ,laston=@laston
                        ,signup_adcode=@signup_adcode
                        ,zodiac_sign=@zodiac_sign
                        ,openingLineLanguage=@openingLineLanguage
                    WHERE user_id=@userId

                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_createProfile
                        SELECT @RETURN = 0
                    END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_createProfile
                        SELECT @RETURN = 99
                    END
            END
        ELSE --INSERT
            BEGIN
                BEGIN TRAN TRAN_createProfile
                    INSERT INTO a_profile_dating (
                         user_id
                        ,height_cm
                        ,height_in
                        ,birthdate
                        ,country
                        ,country_area
                        ,city
                        ,lat_rad
                        ,long_rad
                        ,zipcode
                        ,attributes
                        ,gender
                        ,user_type
                        ,myidentity
                        ,headline
                        ,created_on
                        ,approved_on
                        ,username
                        ,show_prefs
                        ,approved
                        ,show
                        ,noshowdescrp
                        ,on_line
                        ,laston
                        ,signup_adcode
                        ,zodiac_sign
                        ,openingLineLanguage
                        ,profileLanguageMask
                        ,profileFeatures
                    )
                    VALUES (
                         @userId
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
                        ,@openingLineLanguage
                        ,@profileLanguageMask
                        ,@profileFeatures
                    )

                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_createProfile
                        SELECT @RETURN = 0
                    END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_createProfile
                        SELECT @RETURN = 99
                    END
            END
        RETURN @RETURN
    END
go
EXEC sp_procxmode 'dbo.wsp_saveProfileById','unchained'
go
IF OBJECT_ID('dbo.wsp_saveProfileById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveProfileById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveProfileById >>>'
go
GRANT EXECUTE ON dbo.wsp_saveProfileById TO web
go
GRANT EXECUTE ON dbo.wsp_saveProfileById TO guest
go

