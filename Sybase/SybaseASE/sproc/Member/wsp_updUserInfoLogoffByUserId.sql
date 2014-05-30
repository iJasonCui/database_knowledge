IF OBJECT_ID('dbo.wsp_updUserInfoLogoffByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoLogoffByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoLogoffByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoLogoffByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoLogoffByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  November 12 2002
**   Description:  Update last_logoff user info by user id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoLogoffByUserId
 @last_logoff INT
,@userId NUMERIC(12,0)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoLogoffByUserId

	UPDATE user_info 
	SET last_logoff = @last_logoff,
            dateModified = @dateNow
	WHERE user_id = @userId

	IF @@error = 0
		BEGIN
			COMMIT TRAN TRAN_updUserInfoLogoffByUserId
			RETURN 0
		END
	ELSE
		BEGIN
			ROLLBACK TRAN TRAN_updUserInfoLogoffByUserId
			RETURN 99
		END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoLogoffByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoLogoffByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoLogoffByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoLogoffByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoLogoffByUserId','unchained'
go
