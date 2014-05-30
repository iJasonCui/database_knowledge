IF OBJECT_ID('dbo.wsp_cntEmailHistoryApproved') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntEmailHistoryApproved
    IF OBJECT_ID('dbo.wsp_cntEmailHistoryApproved') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntEmailHistoryApproved >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntEmailHistoryApproved >>>'
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

CREATE PROCEDURE wsp_cntEmailHistoryApproved
 @dateFrom DATETIME
,@dateTo   DATETIME
AS

SELECT COUNT(*)
FROM EmailHistory
WHERE status = 'A'
AND dateCreated >= @dateFrom
AND dateCreated <= @dateTo

 
go
GRANT EXECUTE ON dbo.wsp_cntEmailHistoryApproved TO web
go
IF OBJECT_ID('dbo.wsp_cntEmailHistoryApproved') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntEmailHistoryApproved >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntEmailHistoryApproved >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntEmailHistoryApproved','unchained'
go
