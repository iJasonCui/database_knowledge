IF OBJECT_ID('dbo.wsp_getImAcceptOn') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getImAcceptOn
    IF OBJECT_ID('dbo.wsp_getImAcceptOn') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getImAcceptOn >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getImAcceptOn >>>'
END
go

CREATE PROCEDURE wsp_getImAcceptOn
 @userId             NUMERIC(12,0)
AS

SELECT acceptImOn 
  FROM dbo.user_info 
 WHERE user_id = @userId

go
GRANT EXECUTE ON dbo.wsp_getImAcceptOn TO web
go
IF OBJECT_ID('dbo.wsp_getImAcceptOn') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getImAcceptOn >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getImAcceptOn >>>'
go
EXEC sp_procxmode 'dbo.wsp_getImAcceptOn','unchained'
go
