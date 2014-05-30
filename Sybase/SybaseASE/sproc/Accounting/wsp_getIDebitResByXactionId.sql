IF OBJECT_ID('dbo.wsp_getIDebitResByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getIDebitResByXactionId
    IF OBJECT_ID('dbo.wsp_getIDebitResByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getIDebitResByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getIDebitResByXactionId >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Returns IDebit response for the given xactionId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE dbo.wsp_getIDebitResByXactionId
    @xactionId NUMERIC(12,0)
AS

BEGIN
    SELECT iDebitTrack2
          ,iDebitIssConf
          ,iDebitIssName
          ,iDebitIssLang
          ,iDebitVersion
          ,errorMessage
    FROM IDebitResponse
    WHERE xactionId = @xactionId

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getIDebitResByXactionId TO web
go

IF OBJECT_ID('dbo.wsp_getIDebitResByXactionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getIDebitResByXactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getIDebitResByXactionId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getIDebitResByXactionId','unchained'
go
