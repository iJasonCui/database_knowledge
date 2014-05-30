IF OBJECT_ID('dbo.wsp_delEmailHistoryByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delEmailHistoryByUserId
    IF OBJECT_ID('dbo.wsp_delEmailHistoryByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delEmailHistoryByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delEmailHistoryByUserId >>>'
END
go
 /******************************************************************
**
** CREATION:
**   Author: Jack Veiga/Yan Liu
**   Date: May 2003 
**   Description: Deletes row from EmailHistory by userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_delEmailHistoryByUserId
@userId NUMERIC(12,0)
AS

BEGIN TRAN TRN_delEmailHistoryByUserId

DELETE EmailHistory
WHERE userId = @userId

IF @@error = 0
	BEGIN
		COMMIT TRAN TRN_delEmailHistoryByUserId
		RETURN 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN TRN_delEmailHistoryByUserId
		RETURN 99
	END
 
go
GRANT EXECUTE ON dbo.wsp_delEmailHistoryByUserId TO web
go
IF OBJECT_ID('dbo.wsp_delEmailHistoryByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delEmailHistoryByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delEmailHistoryByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_delEmailHistoryByUserId','unchained'
go
