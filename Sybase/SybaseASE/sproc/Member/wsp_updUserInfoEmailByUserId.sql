IF OBJECT_ID('dbo.wsp_updUserInfoEmailByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoEmailByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoEmailByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoEmailByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoEmailByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  May 2003
**   Description:  Update user info email info by user_id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoEmailByUserId
 @userId        NUMERIC(12,0)
,@email         VARCHAR(24)
,@emailStatus   CHAR(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoEmailByUserId

UPDATE user_info SET
 email = @email
,emailStatus = @emailStatus
,dateModified=@dateNow
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoEmailByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoEmailByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoEmailByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoEmailByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoEmailByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoEmailByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoEmailByUserId','unchained'
go
