IF OBJECT_ID('dbo.wsp_getWapInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getWapInfo
    IF OBJECT_ID('dbo.wsp_getWapInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getWapInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getWapInfo >>>'
END
go

 /***********************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 25, 2006
**   Description:  Retrieves wapInfo by wapId 
**
*************************************************************************/
CREATE PROCEDURE  wsp_getWapInfo
@wapId VARCHAR(128)
AS
BEGIN
SELECT info
FROM WapInfo
WHERE wapId = @wapId

RETURN @@error
END
go
GRANT EXECUTE ON dbo.wsp_getWapInfo TO web
go
IF OBJECT_ID('dbo.wsp_getWapInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getWapInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getWapInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_getWapInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_getWapInfo TO web
go

