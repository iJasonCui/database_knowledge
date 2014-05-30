IF OBJECT_ID('dbo.wsp_getAccountXactionDwntm') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountXactionDwntm
    IF OBJECT_ID('dbo.wsp_getAccountXactionDwntm') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountXactionDwntm >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountXactionDwntm >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  September 19 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getAccountXactionDwntm
  @dateFrom DATETIME
 ,@dateTo DATETIME
 ,@usageTypeId tinyint
AS
    BEGIN
        SELECT userId, creditTypeId, credits
        FROM AccountTransaction, UsageType
        WHERE dateCreated > @dateFrom AND dateCreated < @dateTo 
        AND UsageType.xactionTypeId = AccountTransaction.xactionTypeId
	    AND usageTypeId = @usageTypeId
        AT ISOLATION READ UNCOMMITTED

	   RETURN @@error
    END
 
go
GRANT EXECUTE ON dbo.wsp_getAccountXactionDwntm TO web
go
IF OBJECT_ID('dbo.wsp_getAccountXactionDwntm') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountXactionDwntm >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountXactionDwntm >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAccountXactionDwntm','unchained'
go
