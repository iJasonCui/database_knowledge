IF OBJECT_ID('dbo.wsp_getIDebitTransByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getIDebitTransByDate
    IF OBJECT_ID('dbo.wsp_getIDebitTransByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getIDebitTransByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getIDebitTransByDate >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Returns all IDebit transaction for the given userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE dbo.wsp_getIDebitTransByDate
     @userId      NUMERIC(12,0)
    ,@dateCreated DATETIME
AS

BEGIN
    SELECT  a.xactionId
           ,a.dateCreated
           ,b.errorNumber
           ,b.errorDescription
           ,b.transactionError
           ,b.transactionApproved
           ,b.exactRespCode
           ,b.exactRespMessage
           ,b.bankRespCode
           ,b.bankRespMessage
           ,b.authorizationNumber
           ,c.errorMessage
      FROM IDebitRequest a, IDebitTransaction b, IDebitResponse c
     WHERE a.userId = @userId
       AND a.dateCreated >= @dateCreated
       AND a.xactionId *= b.xactionId
       AND a.xactionId *= c.xactionId
    ORDER BY a.xactionId
    
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getIDebitTransByDate TO web
go

IF OBJECT_ID('dbo.wsp_getIDebitTransByDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getIDebitTransByDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getIDebitTransByDate >>>'
go

EXEC sp_procxmode 'dbo.wsp_getIDebitTransByDate','unchained'
go
