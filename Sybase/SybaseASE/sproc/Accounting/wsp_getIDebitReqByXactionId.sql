IF OBJECT_ID('dbo.wsp_getIDebitReqByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getIDebitReqByXactionId
    IF OBJECT_ID('dbo.wsp_getIDebitReqByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getIDebitReqByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getIDebitReqByXactionId >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Returns IDebit request for the given xactionId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE dbo.wsp_getIDebitReqByXactionId
    @xactionId NUMERIC(12,0)
AS

BEGIN
    SELECT userId
          ,totalAmount
          ,currencyCode
    FROM IDebitRequest
    WHERE xactionId = @xactionId

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getIDebitReqByXactionId TO web
go

IF OBJECT_ID('dbo.wsp_getIDebitReqByXactionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getIDebitReqByXactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getIDebitReqByXactionId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getIDebitReqByXactionId','unchained'
go
