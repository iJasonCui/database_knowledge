IF OBJECT_ID('dbo.wsp_updFTPPassword') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updFTPPassword
    IF OBJECT_ID('dbo.wsp_updFTPPassword') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updFTPPassword >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updFTPPassword >>>'
END
go
CREATE PROCEDURE wsp_updFTPPassword
    @password        VARCHAR(30)
AS

BEGIN TRAN TRAN_updFTPPassword

  
  INSERT INTO PaymentechFTPPassword
   (
     dateCreated,
     FTPPassword
  )
  VALUES (
     getDate(),
     @password
  )

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updFTPPassword
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updFTPPassword
        RETURN 99
    END

go
IF OBJECT_ID('dbo.wsp_updFTPPassword') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updFTPPassword >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updFTPPassword >>>'
go
EXEC sp_procxmode 'dbo.wsp_updFTPPassword','unchained'
go
GRANT EXECUTE ON dbo.wsp_updFTPPassword TO web
go
