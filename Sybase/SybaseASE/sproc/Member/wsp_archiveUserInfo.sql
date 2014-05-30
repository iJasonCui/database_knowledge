IF OBJECT_ID('dbo.wsp_archiveUserInfo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_archiveUserInfo
    IF OBJECT_ID('dbo.wsp_archiveUserInfo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_archiveUserInfo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_archiveUserInfo >>>'
END
go
 /***************************************************************************
***
**
** CREATION:
**   Author:  Jason Cui
**   Date:  March 2004
**   Description:  
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:   Oct 2005
**   Description: eliminate a bunch of obsolete columns
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:   Oct 2005
**   Description: eliminated update of user_info_hist, write row to user_info_deleted, 
**                to be picked up by reporting to update status, dateModified in user_info on reporting.
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_archiveUserInfo @user_id numeric(12,0)
AS
BEGIN

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

BEGIN TRANSACTION TRAN_archiveUserInfo
	
        INSERT user_info_deleted (userId, dateCreated)
        SELECT user_id, @dateNow	FROM user_info WHERE user_id = @user_id

	IF @@error != 0
	BEGIN
		ROLLBACK TRANSACTION TRAN_archiveUserInfo
		RETURN 98
	END

	DELETE user_info WHERE user_id = @user_id

	IF @@error != 0
	BEGIN
		ROLLBACK TRANSACTION TRAN_archiveUserInfo
		RETURN 99
	END
	ELSE BEGIN
		COMMIT TRANSACTION TRAN_archiveUserInfo
		
		IF @@error = 0	RETURN 0
		ELSE RETURN 99 
	END
END
go
GRANT EXECUTE ON dbo.wsp_archiveUserInfo TO web
go
IF OBJECT_ID('dbo.wsp_archiveUserInfo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_archiveUserInfo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_archiveUserInfo >>>'
go
EXEC sp_procxmode 'dbo.wsp_archiveUserInfo','unchained'
go
GRANT EXECUTE ON dbo.wsp_archiveUserInfo TO web
go

