IF OBJECT_ID('dbo.wsp_cntDailyPurchaseDeclines') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntDailyPurchaseDeclines
    IF OBJECT_ID('dbo.wsp_cntDailyPurchaseDeclines') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntDailyPurchaseDeclines >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntDailyPurchaseDeclines >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  December 2007
**   Description:  Added xactionTypeId = 44
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_cntDailyPurchaseDeclines
 @fromDate 				DATETIME
,@toDate 				DATETIME
AS

SELECT COUNT(*),COUNT(DISTINCT userId) 
FROM Purchase 
WHERE dateCreated >= @fromDate AND dateCreated <= @toDate
AND xactionTypeId IN (7, 44)
AT ISOLATION READ UNCOMMITTED
RETURN @@error
go
GRANT EXECUTE ON dbo.wsp_cntDailyPurchaseDeclines TO web
go
IF OBJECT_ID('dbo.wsp_cntDailyPurchaseDeclines') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntDailyPurchaseDeclines >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntDailyPurchaseDeclines >>>'
go
