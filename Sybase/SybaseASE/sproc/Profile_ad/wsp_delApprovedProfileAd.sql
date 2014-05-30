IF OBJECT_ID('dbo.wsp_delApprovedProfileAd') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delApprovedProfileAd
    IF OBJECT_ID('dbo.wsp_delApprovedProfileAd') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delApprovedProfileAd >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delApprovedProfileAd >>>'
END
go
CREATE PROCEDURE wsp_delApprovedProfileAd
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@approved_on int
,@languageMask int

AS

BEGIN TRAN TRAN_delApprovedProfileAd

    UPDATE a_profile_dating SET
    approved = NULL,
    approved_on = NULL
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_delApprovedProfileAd
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_delApprovedProfileAd
            RETURN 99
        END
go
GRANT EXECUTE ON dbo.wsp_delApprovedProfileAd TO web
go
IF OBJECT_ID('dbo.wsp_delApprovedProfileAd') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delApprovedProfileAd >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delApprovedProfileAd >>>'
go
EXEC sp_procxmode 'dbo.wsp_delApprovedProfileAd','unchained'
go
GRANT EXECUTE ON dbo.wsp_delApprovedProfileAd TO web
go
