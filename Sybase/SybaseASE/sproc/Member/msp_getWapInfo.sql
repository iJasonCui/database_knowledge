IF OBJECT_ID('dbo.msp_getWapInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_getWapInfo
    IF OBJECT_ID('dbo.msp_getWapInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_getWapInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_getWapInfo >>>'
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
CREATE PROCEDURE  msp_getWapInfo
@wapId VARCHAR(128)
AS
BEGIN
SELECT info
FROM WapInfo
WHERE wapId = @wapId

RETURN @@error
END
go
GRANT EXECUTE ON dbo.msp_getWapInfo TO web
go
IF OBJECT_ID('dbo.msp_getWapInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.msp_getWapInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_getWapInfo >>>'
go
EXEC sp_procxmode 'dbo.msp_getWapInfo','unchained'
go
GRANT EXECUTE ON dbo.msp_getWapInfo TO web
go

