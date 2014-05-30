IF OBJECT_ID('dbo.wsp_getRiskMgmtReplyCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRiskMgmtReplyCode
    IF OBJECT_ID('dbo.wsp_getRiskMgmtReplyCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRiskMgmtReplyCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRiskMgmtReplyCode >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  September 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getRiskMgmtReplyCode 

AS

SELECT riskMgmtReplyCode,
       riskMgmtTypeId,
       assignedResultId,
       result,
       explanation,
       screenDisplay,
       replyCodeCounter
  FROM RiskMgmtReplyCode

RETURN @@error
go
IF OBJECT_ID('dbo.wsp_getRiskMgmtReplyCode') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRiskMgmtReplyCode >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRiskMgmtReplyCode >>>'
go
EXEC sp_procxmode 'dbo.wsp_getRiskMgmtReplyCode','anymode'
go
GRANT EXECUTE ON dbo.wsp_getRiskMgmtReplyCode TO web
go
