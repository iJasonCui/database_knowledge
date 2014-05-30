IF OBJECT_ID('dbo.wsp_saveProfileFeaturesById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveProfileFeaturesById
    IF OBJECT_ID('dbo.wsp_saveProfileFeaturesById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveProfileFeaturesById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveProfileFeaturesById >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Yadira Genoves
**   Date:  August 2009
**   Description:  Updates profileFeatures column on profile table
**
*************************************************************************/

CREATE PROCEDURE wsp_saveProfileFeaturesById
@userId numeric (12,0)
,@profileFeatures int

AS
DECLARE @RETURN INT

BEGIN
    IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id = @userId)
        BEGIN
            BEGIN TRAN TRAN_updateProfileFeatures
                UPDATE a_profile_dating
                SET  profileFeatures=@profileFeatures
                WHERE user_id=@userId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updateProfileFeatures
                    SELECT @RETURN = 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updateProfileFeatures
                    SELECT @RETURN = 99
                END
        END
    RETURN @RETURN
END
go
EXEC sp_procxmode 'dbo.wsp_saveProfileFeaturesById','unchained'
go
IF OBJECT_ID('dbo.wsp_saveProfileFeaturesById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveProfileFeaturesById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveProfileFeaturesById >>>'
go
GRANT EXECUTE ON dbo.wsp_saveProfileFeaturesById TO web
go
GRANT EXECUTE ON dbo.wsp_saveProfileFeaturesById TO guest
go

