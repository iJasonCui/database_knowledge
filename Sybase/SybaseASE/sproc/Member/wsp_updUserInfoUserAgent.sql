IF OBJECT_ID('dbo.wsp_updUserInfoUserAgent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoUserAgent
    IF OBJECT_ID('dbo.wsp_updUserInfoUserAgent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoUserAgent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoUserAgent >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yahya Kola
**   Date:  July 15 2003
**   Description:  Updates extended user agent
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/
CREATE PROCEDURE wsp_updUserInfoUserAgent
 @userId     NUMERIC(12,0)
,@user_agent VARCHAR(80)

AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoUserAgent

UPDATE user_info 
SET user_agent = @user_agent 
,dateModified    = @dateNow
WHERE user_id = @userId

IF @@error = 0
	BEGIN
		COMMIT TRAN TRAN_updUserInfoUserAgent
		RETURN 0
	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_updUserInfoUserAgent
		RETURN 99
	END
go
GRANT EXECUTE ON wsp_updUserInfoUserAgent TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoUserAgent') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoUserAgent >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoUserAgent >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoUserAgent','unchained'
go
