IF OBJECT_ID('dbo.wsp_updUserInfoEStatByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoEStatByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoEStatByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoEStatByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoEStatByUserId >>>'
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

CREATE PROCEDURE wsp_updUserInfoEStatByUserId
 @userId        NUMERIC(12,0)
,@emailStatus   CHAR(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoEStatByUserId

UPDATE user_info 
SET emailStatus = @emailStatus
   ,dateModified=@dateNow
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoEStatByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoEStatByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoEStatByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoEStatByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoEStatByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoEStatByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoEStatByUserId','unchained'
go
