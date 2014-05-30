IF OBJECT_ID('dbo.wsp_getCreditBalanceForward') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditBalanceForward
    IF OBJECT_ID('dbo.wsp_getCreditBalanceForward') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditBalanceForward >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditBalanceForward >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  Sept 14, 2003
**   Description:  retrieves the balance forward for the given user, prior to the given date
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getCreditBalanceForward
@userId NUMERIC(12,0),
@cutoffDate DATETIME 
AS
    BEGIN
       SET ROWCOUNT 1
       SELECT balance
           FROM AccountTransaction
           WHERE userId = @userId
           AND dateCreated < @cutoffDate
           ORDER BY dateCreated desc
  
           AT ISOLATION READ UNCOMMITTED
       RETURN @@error
    END
go
GRANT EXECUTE ON dbo.wsp_getCreditBalanceForward TO web
go
IF OBJECT_ID('dbo.wsp_getCreditBalanceForward') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditBalanceForward >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditBalanceForward >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCreditBalanceForward','unchained'
go

