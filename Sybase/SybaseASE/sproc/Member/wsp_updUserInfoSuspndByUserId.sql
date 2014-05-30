IF OBJECT_ID('dbo.wsp_updUserInfoSuspndByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoSuspndByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoSuspndByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoSuspndByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoSuspndByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update status user info by user id to suspend and reinstate
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoSuspndByUserId
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

IF (@statusCode = "A")
  BEGIN

    BEGIN TRAN TRAN_updUserInfoSuspndByUserId

    UPDATE user_info SET
    status = 'A'
    ,suspendedon = NULL
    ,dateModified    = @dateNow
WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoSuspndByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoSuspndByUserId
            RETURN 99
        END
  END
ELSE
  BEGIN
    BEGIN TRAN TRAN_updUserInfoSuspndByUserId

    UPDATE user_info SET
    status = 'S'
    ,onhold_greeting = 'Y'
    ,dateModified    = @dateNow
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoSuspndByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoSuspndByUserId
            RETURN 99
        END
  END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoSuspndByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoSuspndByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoSuspndByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoSuspndByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoSuspndByUserId','unchained'
go
