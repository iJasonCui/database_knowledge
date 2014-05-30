IF OBJECT_ID('dbo.wsp_cntDailyPurchaseTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntDailyPurchaseTrans
    IF OBJECT_ID('dbo.wsp_cntDailyPurchaseTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntDailyPurchaseTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntDailyPurchaseTrans >>>'
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
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_cntDailyPurchaseTrans
@fromDate 				DATETIME
,@toDate 				DATETIME
AS

BEGIN
    SELECT count(*) FROM Purchase WHERE dateCreated >= @fromDate AND dateCreated <= @toDate
RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_cntDailyPurchaseTrans TO web
go
IF OBJECT_ID('dbo.wsp_cntDailyPurchaseTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntDailyPurchaseTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntDailyPurchaseTrans >>>'
go
