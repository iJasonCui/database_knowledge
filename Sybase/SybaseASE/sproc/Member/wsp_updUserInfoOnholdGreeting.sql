IF OBJECT_ID('dbo.wsp_updUserInfoOnholdGreeting') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoOnholdGreeting
    IF OBJECT_ID('dbo.wsp_updUserInfoOnholdGreeting') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoOnholdGreeting >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoOnholdGreeting >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 4 2002
**   Description:  Update onhold_greeting column of user_info by user_id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoOnholdGreeting
 @userId NUMERIC(12,0)
,@onholdGreeting char(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoOnholdGreeting

    UPDATE user_info SET
    onhold_greeting = @onholdGreeting,
    dateModified    = @dateNow
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoOnholdGreeting
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoOnholdGreeting
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoOnholdGreeting TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoOnholdGreeting') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoOnholdGreeting >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoOnholdGreeting >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoOnholdGreeting','unchained'
go
