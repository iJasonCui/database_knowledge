IF OBJECT_ID('dbo.wsp_getRiskMgmtType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRiskMgmtType
    IF OBJECT_ID('dbo.wsp_getRiskMgmtType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRiskMgmtType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRiskMgmtType >>>'
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

CREATE PROCEDURE wsp_getRiskMgmtType 

AS

SELECT riskMgmtTypeId,
       riskMgmtTypeCode,
       riskMgmtTypeName
  FROM RiskMgmtType

RETURN @@error
go
IF OBJECT_ID('dbo.wsp_getRiskMgmtType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRiskMgmtType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRiskMgmtType >>>'
go
EXEC sp_procxmode 'dbo.wsp_getRiskMgmtType','anymode'
go
GRANT EXECUTE ON dbo.wsp_getRiskMgmtType TO web
go
