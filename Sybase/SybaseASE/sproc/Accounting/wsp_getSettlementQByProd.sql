IF OBJECT_ID('dbo.wsp_getSettlementQByProd') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSettlementQByProd
    IF OBJECT_ID('dbo.wsp_getSettlementQByProd') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSettlementQByProd >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSettlementQByProd >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  July 16 2008
**   Description:  Retrieves Settlement Queue 
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_getSettlementQByProd
@from DATETIME,
@to DATETIME,
@productId int
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
	WHERE q.dateCreated >= @from AND q.dateCreated <= @to AND q.xactionId=p.xactionId and q.productId = @productId 
	ORDER BY q.dateCreated

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getSettlementQByProd TO web
go
IF OBJECT_ID('dbo.wsp_getSettlementQByProd') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSettlementQByProd >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSettlementQByProd >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSettlementQByProd','unchained'
go
