IF OBJECT_ID('dbo.wsp_getAllUsageCellDetails') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllUsageCellDetails
    IF OBJECT_ID('dbo.wsp_getAllUsageCellDetails') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllUsageCellDetails >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllUsageCellDetails >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all usage cells
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: October 2004
**   Description: also retrieve freeCreditTypeId associated with usageCell, used
**                when free cells to specify a creditType for reporting
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: November 2004
**   Description: also retrieve description used for admin app
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllUsageCellDetails
AS
  BEGIN  
	SELECT 
          d.usageCellId,
          usageTypeId,
          credits,
          d.duration,
          freeCreditTypeId,
          c.description,
          c.cellDuration
        FROM UsageCellDetail d, UsageCell c
        WHERE c.usageCellId = d.usageCellId
        ORDER BY usageCellId, usageTypeId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllUsageCellDetails') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllUsageCellDetails >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllUsageCellDetails >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllUsageCellDetails TO web
go


