use Profile_ad
go
IF OBJECT_ID('dbo.wsp_removeProfileFeaturesById') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_removeProfileFeaturesById
    IF OBJECT_ID('dbo.wsp_removeProfileFeaturesById') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_removeProfileFeaturesById >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_removeProfileFeaturesById >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Yadira Genoves
**   Date:  August 2009
**   Description:  remove Features to the user
**
*************************************************************************/

CREATE PROCEDURE wsp_removeProfileFeaturesById
@userId numeric (12,0)
,@profileFeatures int

AS
DECLARE @RETURN INT
DECLARE @profileFeaturesOld INT

BEGIN
    IF EXISTS (SELECT 1 FROM a_profile_dating WHERE user_id = @userId)
        BEGIN
            BEGIN TRAN TRAN_updateProfileFeatures
                --Get the previous value for the features
                SELECT @profileFeaturesOld = profileFeatures FROM a_profile_dating WHERE user_id=@userId
            
                --if the feature is null the initialize the value to 0
                IF @profileFeaturesOld IS NULL
                    BEGIN
                        SELECT @profileFeaturesOld = 0
                    END
                ELSE
                    BEGIN
                        SELECT @profileFeatures = @profileFeaturesOld - @profileFeatures
                    END
                    
                IF @profileFeatures < 0
                    BEGIN
                        SELECT @profileFeatures = 0
                    END                    
                
                --Add the previous value and the new feature the user buys
                --SELECT @profileFeatures = @profileFeaturesOld & @profileFeatures
                
                UPDATE a_profile_dating
                SET  profileFeatures = @profileFeatures
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
EXEC sp_procxmode 'dbo.wsp_removeProfileFeaturesById','unchained'
go
IF OBJECT_ID('dbo.wsp_removeProfileFeaturesById') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_removeProfileFeaturesById >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_removeProfileFeaturesById >>>'
go
GRANT EXECUTE ON dbo.wsp_removeProfileFeaturesById TO guest
go
GRANT EXECUTE ON dbo.wsp_removeProfileFeaturesById TO web
go
