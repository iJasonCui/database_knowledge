IF OBJECT_ID('dbo.wsp_stopIm') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_stopIm
    IF OBJECT_ID('dbo.wsp_stopIm') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_stopIm >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_stopIm >>>'
END
go

CREATE PROCEDURE wsp_stopIm
 @userId             NUMERIC(12,0)
,@dateAccept         DATETIME 
AS


BEGIN TRAN TRAN_stopIm

UPDATE dbo.user_info 
   SET acceptImOn=@dateAccept
 WHERE user_id = @userId

IF @@error = 0
	BEGIN
  		COMMIT TRAN TRAN_stopIm
    	RETURN 0
  	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_stopIm
		RETURN 99
	END
 
go
GRANT EXECUTE ON dbo.wsp_stopIm TO web
go
IF OBJECT_ID('dbo.wsp_stopIm') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_stopIm >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_stopIm >>>'
go
EXEC sp_procxmode 'dbo.wsp_stopIm','unchained'
go
