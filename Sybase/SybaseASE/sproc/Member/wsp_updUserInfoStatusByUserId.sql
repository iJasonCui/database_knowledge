IF OBJECT_ID('dbo.wsp_updUserInfoStatusByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoStatusByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoStatusByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoStatusByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoStatusByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update status user info by user id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoStatusByUserId
 @statusCode    CHAR(1)
,@userId        NUMERIC(12,0)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoStatusByUserId

UPDATE user_info SET
status = @statusCode
,dateModified    = @dateNow
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoStatusByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoStatusByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoStatusByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoStatusByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoStatusByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoStatusByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoStatusByUserId','unchained'
go
