IF OBJECT_ID('dbo.wsp_getAccountXactionCredSum') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountXactionCredSum
    IF OBJECT_ID('dbo.wsp_getAccountXactionCredSum') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountXactionCredSum >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountXactionCredSum >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  Sept 18 2003
**   Description: Gets record count and credit sum for given date range, for downtime compensation report
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getAccountXactionCredSum
  @dateFrom DATETIME
 ,@dateTo DATETIME
 ,@usageTypeId TINYINT
AS

    BEGIN
        SELECT COUNT(*) AS num, SUM(credits) AS total
        FROM AccountTransaction, UsageType
        WHERE dateCreated > @dateFrom AND dateCreated < @dateTo
        AND UsageType.xactionTypeId = AccountTransaction.xactionTypeId
	    AND usageTypeId = @usageTypeId
	    AT ISOLATION READ UNCOMMITTED

	   RETURN @@error
    END
go
GRANT EXECUTE ON dbo.wsp_getAccountXactionCredSum TO web
go
IF OBJECT_ID('dbo.wsp_getAccountXactionCredSum') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountXactionCredSum >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountXactionCredSum >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAccountXactionCredSum','unchained'
go

