IF OBJECT_ID('dbo.wsp_MobileId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_MobileId
    IF OBJECT_ID('dbo.wsp_MobileId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_MobileId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_MobileId >>>'
END
go

CREATE PROCEDURE wsp_MobileId @mobileId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_MobileId
    UPDATE MobileId
    SET mobileId = mobileId + 1

    IF @@error = 0
        BEGIN
            SELECT @mobileId = mobileId
            FROM MobileId
            COMMIT TRAN TRAN_wsp_MobileId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_MobileId
		  RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_MobileId TO web
go
IF OBJECT_ID('dbo.wsp_MobileId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_MobileId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_MobileId >>>'
go
EXEC sp_procxmode 'dbo.wsp_MobileId','unchained'
go
