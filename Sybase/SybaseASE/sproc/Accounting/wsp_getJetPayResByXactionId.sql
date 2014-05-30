IF OBJECT_ID('dbo.wsp_getJetPayResByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getJetPayResByXactionId
    IF OBJECT_ID('dbo.wsp_getJetPayResByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJetPayResByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJetPayResByXactionId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          Sep. 14, 2004
**   Description:   Returns JetPay response for the given transactionId
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getJetPayResByXactionId
 @transactionId CHAR(18)
AS

BEGIN
    SELECT userId,
           actionCode,
           approval,
           addressMatch,
           zipMatch,
           avs,
           responseText,
           errMsg,
           lastEvent,
           dateCreated
    FROM JetPayResponse
    WHERE transactionId = @transactionId

    RETURN @@error
END 
go
GRANT EXECUTE ON dbo.wsp_getJetPayResByXactionId TO web
go
IF OBJECT_ID('dbo.wsp_getJetPayResByXactionId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getJetPayResByXactionId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJetPayResByXactionId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getJetPayResByXactionId','unchained'
go
