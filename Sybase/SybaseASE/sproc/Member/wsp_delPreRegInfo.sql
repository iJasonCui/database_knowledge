USE Member
go

IF OBJECT_ID('dbo.wsp_delPreRegInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delPreRegInfo
    IF OBJECT_ID('dbo.wsp_delPreRegInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delPreRegInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delPreRegInfo >>>'  
END
go

CREATE PROCEDURE wsp_delPreRegInfo
 @email              VARCHAR(129)
AS

BEGIN TRAN TRAN_delPreRegInfo

IF EXISTS (SELECT 1  FROM PreRegInfo WHERE email = @email) 

BEGIN
    DELETE dbo.PreRegInfo WHERE email = @email
END



IF @@error = 0
  BEGIN
    COMMIT TRAN TRAN_delPreRegInfo
    RETURN 0
  END
ELSE
  BEGIN
		ROLLBACK TRAN TRAN_delPreRegInfo
		RETURN 99
  END


go
IF OBJECT_ID('dbo.wsp_delPreRegInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delPreRegInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delPreRegInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_delPreRegInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_delPreRegInfo TO web
go



