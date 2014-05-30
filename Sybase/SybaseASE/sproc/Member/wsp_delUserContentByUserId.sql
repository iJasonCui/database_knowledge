IF OBJECT_ID('dbo.wsp_delUserContentByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delUserContentByUserId
    IF OBJECT_ID('dbo.wsp_delUserContentByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delUserContentByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delUserContentByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  July 2003
**   Description:  Deletes rows from UserContent by user id
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delUserContentByUserId
@userId NUMERIC(12,0)  
AS

BEGIN TRAN TRAN_delUserContentByUserId

DELETE UserContent
WHERE userId = @userId           

IF @@error = 0 
	BEGIN
		COMMIT TRAN TRAN_delUserContentByUserId
		RETURN 0
	END
ELSE 
	BEGIN
		ROLLBACK TRAN TRAN_delUserContentByUserId
		RETURN 99
	END
go
GRANT EXECUTE ON dbo.wsp_delUserContentByUserId TO web
go
IF OBJECT_ID('dbo.wsp_delUserContentByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delUserContentByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delUserContentByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_delUserContentByUserId','unchained'
go
