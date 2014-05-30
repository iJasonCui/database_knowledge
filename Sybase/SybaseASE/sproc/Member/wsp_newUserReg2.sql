IF OBJECT_ID('dbo.wsp_newUserReg2') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserReg2
    IF OBJECT_ID('dbo.wsp_newUserReg2') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserReg2 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserReg2 >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         May 2008  
**   Description:  Inserts row in user_info  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_newUserReg2
 @userId               NUMERIC(12,0)
,@username             VARCHAR(129)
,@password             VARCHAR(16)
,@userType             CHAR(1)
,@status               CHAR(1)
,@gender               CHAR(1)
,@birthdate            SMALLDATETIME
,@email                VARCHAR(129)
,@emailStatus          CHAR(1)
,@context              CHAR(3)
,@adcode               VARCHAR(30)
,@heightCm             TINYINT
,@prefUnit             CHAR(1)
,@prefLaston           CHAR(1)
,@userAgent            VARCHAR(80)
,@postalCode           VARCHAR(10)
,@latRad               INT
,@longRad              INT
,@countryId            SMALLINT
,@stateId              INT
,@countyId             INT
,@cityId               INT
,@localeId             INT
,@signupIP             NUMERIC(12,0)
,@languagesSpokenMask  INT
,@searchLanguageMask   INT
,@brand varCHAR(5)
AS

BEGIN
    -- set convert attributes
    SELECT @username = LTRIM(RTRIM(UPPER(@username)))
    SELECT @password = LTRIM(RTRIM(UPPER(@password)))
    SELECT @email = LTRIM(RTRIM(UPPER(@email)))
    SELECT @postalCode = LTRIM(RTRIM(UPPER(@postalCode)))
    
    DECLARE @returnCode INT
    SELECT @returnCode = 0

    IF EXISTS (SELECT 1 FROM user_info WHERE status != 'J' AND user_id != @userId AND username = @username AND user_type in ('F','P'))
        BEGIN
            SELECT @returnCode = @returnCode + 1
        END

    IF EXISTS (SELECT 1 FROM user_info WHERE status != 'J' AND user_id != @userId AND email = @email AND user_type in ('F','P'))
        BEGIN
            SELECT @returnCode = @returnCode + 2
        END

    IF @returnCode != 0
        BEGIN
            RETURN @returnCode
        END
    ELSE
        BEGIN
            DECLARE
             @universalId   NUMERIC(10,0)
            ,@universalPass INT
            ,@dateNow       DATETIME
            ,@dateInt       INT

            EXEC wsp_UserId @userId OUTPUT
            EXEC wsp_UniversalId @universalId OUTPUT
            EXEC wsp_RandomNumber @universalPass OUTPUT,1000,9999
            EXEC wsp_GetDateGMT @dateNow OUTPUT
            SELECT @dateInt = DATEDIFF(ss, '19700101', @dateNow)
    
            BEGIN TRAN TRAN_newUserReg2
                INSERT INTO dbo.user_info
                (
                     user_id
                    ,username
                    ,password
                    ,user_type
                    ,status
                    ,gender
                    ,birthdate
                    ,email
                    ,emailStatus
                    ,signup_adcode
                    ,signup_context
                    ,height_cm
                    ,preferred_units
                    ,pref_last_on
                    ,user_agent
                    ,zipcode
                    ,lat_rad
                    ,long_rad
                    ,countryId
                    ,jurisdictionId
                    ,secondJurisdictionId
                    ,cityId
                    ,localePref
                    ,signupLocalePref
                    ,signupIP
                    ,languagesSpokenMask
                    ,searchLanguageMask
                    ,signupBrand
                    ,ethnic
                    ,religion
                    ,smoke
                    ,body_type
                    ,universal_id
                    ,universal_password
                    ,signuptime
                    ,laston
                    ,dateModified
                )
                VALUES
                (
                     @userId
                    ,@username
                    ,@password
                    ,@userType
                    ,@status
                    ,@gender
                    ,@birthdate
                    ,@email
                    ,@emailStatus
                    ,@adcode
                    ,@context
                    ,@heightCm
                    ,@prefUnit
                    ,@prefLaston
                    ,@userAgent
                    ,@postalCode
                    ,@latRad
                    ,@longRad
                    ,@countryId
                    ,@stateId
                    ,@countyId
                    ,@cityId
                    ,@localeId
                    ,@localeId
                    ,@signupIP
                    ,@languagesSpokenMask
                    ,@searchLanguageMask
                    ,@brand
                    ,'z'
                    ,'z'
                    ,'z'
                    ,'z'
                    ,@universalId
                    ,@universalPass
                    ,@dateInt
                    ,@dateInt
                    ,@dateNow
                )
            
                IF @@error = 0
                    BEGIN
                        COMMIT TRAN TRAN_newUserReg2
                        SELECT @userId AS userId
                      END
                ELSE
                    BEGIN
                        ROLLBACK TRAN TRAN_newUserReg2
                    END
        END
END

go
EXEC sp_procxmode 'dbo.wsp_newUserReg2','unchained'
go
IF OBJECT_ID('dbo.wsp_newUserReg2') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserReg2 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserReg2 >>>'
go
GRANT EXECUTE ON dbo.wsp_newUserReg2 TO web
go
