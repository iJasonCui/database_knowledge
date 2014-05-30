IF OBJECT_ID('dbo.wsp_getMediaRelFlag') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMediaRelFlag
    IF OBJECT_ID('dbo.wsp_getMediaRelFlag') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMediaRelFlag >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMediaRelFlag >>>'
END
go

CREATE PROCEDURE  wsp_getMediaRelFlag
@userId NUMERIC(12,0)
AS

BEGIN
	SELECT ISNULL(mediaReleaseFlag, 'Y') as mediaReleaseFlag 
    FROM user_info 
	WHERE user_id = @userId

	RETURN @@error
END 
 

go
EXEC sp_procxmode 'dbo.wsp_getMediaRelFlag','unchained'
go
IF OBJECT_ID('dbo.wsp_getMediaRelFlag') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getMediaRelFlag >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMediaRelFlag >>>'
go
GRANT EXECUTE ON dbo.wsp_getMediaRelFlag TO web
go
