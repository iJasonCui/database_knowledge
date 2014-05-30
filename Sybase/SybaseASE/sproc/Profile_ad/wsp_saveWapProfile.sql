IF OBJECT_ID('dbo.wsp_saveWapProfile') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveWapProfile
    IF OBJECT_ID('dbo.wsp_saveWapProfile') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveWapProfile >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveWapProfile >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Oct 2006
**   Description: create wap related profile
**
*************************************************************************/

CREATE PROCEDURE wsp_saveWapProfile
@product char(1)
,@community char(1)
,@userId numeric (12,0)
,@username char(16)
,@myidentity char(16)
,@zipcode char(10)
,@birthdate smalldatetime
,@headline char(120)
,@gender char(1)
,@height_cm int
,@attributes char(64)
,@lat_rad int
,@long_rad int
,@countryId         INT
,@jurisdictionId     INT
,@secondJurisdictionId INT
,@cityId             INT

AS
DECLARE @date DATETIME
,@dateInt INT
,@previousUserId NUMERIC(12,0)
,@previousPid VARCHAR(64)
,@RETURN INT
,@universalId NUMERIC(10,0)
,@randomNumber       INT

EXEC wsp_GetDateGMT @date OUTPUT

SELECT @dateInt = datediff(ss,"Jan 1 00:00 1970",@date)        

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
                        ,birthdate=@birthdate
                        ,lat_rad=@lat_rad
                        ,long_rad=@long_rad
                        ,zipcode=@zipcode
                        ,attributes=@attributes
                        ,gender=@gender
                        ,myidentity=@myidentity
                        ,headline=@headline
                        ,username=@username
                        ,openingLineLanguage=0
                        ,countryId = @countryId
                        ,jurisdictionId = @jurisdictionId
                        ,secondJurisdictionId =@secondJurisdictionId
                        ,cityId = @cityId
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
                        ,birthdate
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
                        ,openingLineLanguage
                        ,profileLanguageMask
                        ,languagesSpokenMask
                        ,countryId
                        ,jurisdictionId
                        ,secondJurisdictionId
                        ,cityId
                    )
                    VALUES (
                         @userId
                        ,@height_cm
                        ,@birthdate
                        ,@lat_rad
                        ,@long_rad
                        ,@zipcode
                        ,@attributes
                        ,@gender
                        ,'F'
                        ,@myidentity
                        ,@headline
                        ,@dateInt
                        ,@dateInt
                        ,@username
                        ,'Y'
                        ,'Y'
                        ,'Y'
                        ,'hbser'
                        ,'N'
                        ,@dateInt
                        ,'0'
                        ,0
                        ,1
                        ,1
                        ,@countryId
                        ,@jurisdictionId
                        ,@secondJurisdictionId
                        ,@cityId
                    )
                IF @@error != 0
                    BEGIN
                        ROLLBACK TRAN TRAN_createProfile
                        SELECT @RETURN = 98
                    END

                INSERT INTO a_dating
                        (user_id
                         ,interest1
                         ,interest2
                         ,interest3
                        )
                VALUES
                        (@userId
                        ,''
                        ,''
                        ,''
                        )
 
                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_createProfile
                        SELECT @RETURN = 0
                    END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_createProfile
                        SELECT @RETURN = 97
                    END
            END
        RETURN @RETURN
    END
go

GRANT EXECUTE ON dbo.wsp_saveWapProfile TO web
go

IF OBJECT_ID('dbo.wsp_saveWapProfile') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveWapProfile >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveWapProfile >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveWapProfile','unchained'
go
