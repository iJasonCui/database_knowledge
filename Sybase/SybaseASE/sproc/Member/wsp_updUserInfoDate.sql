IF OBJECT_ID('dbo.wsp_updUserInfoUserAgent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoDate
    IF OBJECT_ID('dbo.wsp_updUserInfoDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoDate >>>'
END
go
CREATE PROCEDURE wsp_updUserInfoDate
 @userId     NUMERIC(12,0)
AS

DECLARE @dateNow DATETIME
EXEC dbo.wsp_GetDateGMT @dateNow OUTPUT

UPDATE user_info 
SET dateModified = @dateNow
WHERE user_id = @userId

go
GRANT EXECUTE ON wsp_updUserInfoDate TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoDate') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoDate >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoDate >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoDate','unchained'
go
