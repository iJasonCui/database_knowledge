IF OBJECT_ID('dbo.wsp_getSettlementQ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSettlementQ
    IF OBJECT_ID('dbo.wsp_getSettlementQ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSettlementQ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSettlementQ >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  June 7 2008
**   Description:  Retrieves Settlement Queue 
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_getSettlementQ
@from DATETIME,
@to DATETIME
AS

BEGIN
	SELECT
	q.xactionId,
	p.userId,
    q.status,
    (select count(*) from AccountFlag where userId=p.userId) as flagNumber,
	q.dateReviewed,
    q.adminUserId,
	q.dateCreated
	FROM SettlementQueue q, Purchase p 
	WHERE q.dateCreated >= @from AND q.dateCreated <= @to AND q.xactionId=p.xactionId and q.productId = 0
	ORDER BY q.dateCreated

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getSettlementQ TO web
go
IF OBJECT_ID('dbo.wsp_getSettlementQ') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSettlementQ >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSettlementQ >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSettlementQ','unchained'
go
