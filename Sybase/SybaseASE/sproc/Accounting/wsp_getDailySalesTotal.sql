IF OBJECT_ID('dbo.wsp_getDailySalesTotal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getDailySalesTotal
    IF OBJECT_ID('dbo.wsp_getDailySalesTotal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getDailySalesTotal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getDailySalesTotal >>>'
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

CREATE PROCEDURE wsp_getDailySalesTotal
@fromDate 				DATETIME
,@toDate 				DATETIME
AS

BEGIN
    SELECT sum(costUSD) as cost FROM Purchase WHERE dateCreated >= @fromDate AND dateCreated <= @toDate
RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getDailySalesTotal TO web
go
IF OBJECT_ID('dbo.wsp_getDailySalesTotal') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getDailySalesTotal >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getDailySalesTotal >>>'
go
