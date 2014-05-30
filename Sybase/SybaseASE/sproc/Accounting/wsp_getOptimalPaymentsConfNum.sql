IF OBJECT_ID('dbo.wsp_getOptimalPaymentsConfNum') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOptimalPaymentsConfNum
    IF OBJECT_ID('dbo.wsp_getOptimalPaymentsConfNum') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOptimalPaymentsConfNum >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOptimalPaymentsConfNum >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Feb 24 2011
**   Description:  Retrieves OptimalPaymentsResponse confirmation number
**                 for the given xactionId and prefix
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getOptimalPaymentsConfNum
 @xactionId NUMERIC(12,0)
,@prefix CHAR(1)
AS
BEGIN  

    SELECT confirmationNumber
      FROM OptimalPaymentsRequest req, OptimalPaymentsResponse res
     WHERE req.activityId = @xactionId
       AND req.merchantRefNum = rtrim(@prefix)+convert(varchar(20),@xactionId)
       AND req.activityId = res.activityId
       AND req.merchantRefNum = res.merchantRefNum
       AND res.code = 0
       AND res.actionCode IS NULL

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getOptimalPaymentsConfNum TO web
go

IF OBJECT_ID('dbo.wsp_getOptimalPaymentsConfNum') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getOptimalPaymentsConfNum >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOptimalPaymentsConfNum >>>'
go

EXEC sp_procxmode 'dbo.wsp_getOptimalPaymentsConfNum','unchained'
go
