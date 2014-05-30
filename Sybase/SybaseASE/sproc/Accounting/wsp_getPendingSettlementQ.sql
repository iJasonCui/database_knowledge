IF OBJECT_ID('dbo.wsp_getPendingSettlementQ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingSettlementQ
    IF OBJECT_ID('dbo.wsp_getPendingSettlementQ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingSettlementQ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingSettlementQ >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  June 7 2008
**   Description:  Retrieves Pending Settlement Queue if it is too old 
**
**
*************************************************************************/

CREATE PROCEDURE  wsp_getPendingSettlementQ
@olderThan DATETIME
AS

BEGIN
	SELECT
	q.xactionId,
	p.userId,
	q.dateCreated
	FROM SettlementQueue q, Purchase p 
	WHERE q.dateCreated < @olderThan AND status=0 AND q.xactionId=p.xactionId
        AND q.dateCreated > dateadd(dd,-30,getdate())  
	ORDER BY q.dateCreated

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getPendingSettlementQ TO web
go
IF OBJECT_ID('dbo.wsp_getPendingSettlementQ') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingSettlementQ >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingSettlementQ >>>'
go
EXEC sp_procxmode 'dbo.wsp_getPendingSettlementQ','unchained'
go
