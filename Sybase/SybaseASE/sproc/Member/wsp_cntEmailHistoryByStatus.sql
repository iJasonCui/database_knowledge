IF OBJECT_ID('dbo.wsp_cntEmailHistoryByStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntEmailHistoryByStatus
    IF OBJECT_ID('dbo.wsp_cntEmailHistoryByStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntEmailHistoryByStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntEmailHistoryByStatus >>>'
END
go
/***************************************************************************
***
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  June 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_cntEmailHistoryByStatus
 @dateFrom DATETIME
,@dateTo   DATETIME
AS

SELECT status,COUNT(*)
FROM EmailHistory
WHERE dateModified >= @dateFrom
AND dateModified <= @dateTo
GROUP BY status
 
go
GRANT EXECUTE ON dbo.wsp_cntEmailHistoryByStatus TO web
go
IF OBJECT_ID('dbo.wsp_cntEmailHistoryByStatus') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntEmailHistoryByStatus >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntEmailHistoryByStatus >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntEmailHistoryByStatus','unchained'
go
