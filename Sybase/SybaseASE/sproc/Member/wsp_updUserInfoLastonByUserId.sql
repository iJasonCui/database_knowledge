IF OBJECT_ID('dbo.wsp_updUserInfoLastonByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoLastonByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoLastonByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoLastonByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoLastonByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Mark Jaeckle
**   Date:  October 23 2002
**   Description:  Update laston user info by user id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoLastonByUserId
 @laston INT
,@userId NUMERIC(12,0)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoLastonByUserId

	UPDATE user_info
	SET laston = @laston,
            dateModified=@dateNow
	WHERE user_id = @userId

	IF @@error = 0
    	BEGIN
        	COMMIT TRAN TRAN_updUserInfoLastonByUserId
        	RETURN 0
    	END
	ELSE
    	BEGIN
        	ROLLBACK TRAN TRAN_updUserInfoLastonByUserId
        	RETURN 99
    	END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoLastonByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoLastonByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoLastonByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoLastonByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoLastonByUserId','unchained'
go
