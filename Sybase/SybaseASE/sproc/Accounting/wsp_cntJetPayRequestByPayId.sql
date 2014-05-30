IF OBJECT_ID('dbo.wsp_cntJetPayRequestByPayId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntJetPayRequestByPayId
    IF OBJECT_ID('dbo.wsp_cntJetPayRequestByPayId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntJetPayRequestByPayId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntJetPayRequestByPayId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jason Cui 
**   Date:  May 24 2002  
**   Description:  
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntJetPayRequestByPayId
@transactionId CHAR(18)
AS

BEGIN
	SELECT COUNT(*) from JetPayRequest req, JetPayResponse res
	WHERE req.transactionId = res.transactionId
  	AND req.transactionType = 'SALE'
  	AND res.responseText = 'APPROVED'
  	AND res.actionCode = '000'
  	AND req.transactionId = @transactionId

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_cntJetPayRequestByPayId TO web
go
IF OBJECT_ID('dbo.wsp_cntJetPayRequestByPayId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntJetPayRequestByPayId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntJetPayRequestByPayId >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntJetPayRequestByPayId','unchained'
go
