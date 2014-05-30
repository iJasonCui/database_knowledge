IF OBJECT_ID('dbo.wsp_updFirstIdentityTime') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updFirstIdentityTime
    IF OBJECT_ID('dbo.wsp_updFirstIdentityTime') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updFirstIdentityTime >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updFirstIdentityTime >>>'
END
go
  CREATE PROCEDURE wsp_updFirstIdentityTime
 @userId NUMERIC(12,0)
,@firstidentitytime INT
AS
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 4 2002
**   Description:  Update firstidentitytime column of user_info by user_id if
**                 set to NULL
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/
DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updFirstIdentityTime

    UPDATE user_info SET
    firstidentitytime = @firstidentitytime
   ,dateModified = @dateNow
    WHERE user_id = @userId
    AND firstidentitytime = NULL

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updFirstIdentityTime
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updFirstIdentityTime
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updFirstIdentityTime TO web
go
IF OBJECT_ID('dbo.wsp_updFirstIdentityTime') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updFirstIdentityTime >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updFirstIdentityTime >>>'
go
EXEC sp_procxmode 'dbo.wsp_updFirstIdentityTime','unchained'
go
