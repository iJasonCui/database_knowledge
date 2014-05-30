IF OBJECT_ID('dbo.wsp_getFTPPassword') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFTPPassword
    IF OBJECT_ID('dbo.wsp_getFTPPassword') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFTPPassword >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFTPPassword >>>'
END
go
CREATE PROCEDURE wsp_getFTPPassword
    @password        VARCHAR(30) OUTPUT
AS

  SET ROWCOUNT 1
  SELECT @password = FTPPassword FROM PaymentechFTPPassword
    ORDER BY dateCreated DESC

  RETURN 0
go
IF OBJECT_ID('dbo.wsp_getFTPPassword') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFTPPassword >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFTPPassword >>>'
go
EXEC sp_procxmode 'dbo.wsp_getFTPPassword','unchained'
go
GRANT EXECUTE ON dbo.wsp_getFTPPassword TO web
go
