IF OBJECT_ID('dbo.wsp_updUserInfoLogin') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoLogin
    IF OBJECT_ID('dbo.wsp_updUserInfoLogin') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoLogin >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoLogin >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 10 2002
**   Description:  Updates row in user_info
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
**   Author: Andy Tran
**   Date: Jul 30 2008
**   Description: use email address as username
**
******************************************************************************/
CREATE PROCEDURE wsp_updUserInfoLogin
 @userId             NUMERIC(12,0)
,@username           VARCHAR(129)
,@password           VARCHAR(16)
,@email         VARCHAR(129)
,@emailStatus        CHAR(1)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoLogin

UPDATE dbo.user_info SET
 username=LTRIM(UPPER(@username))
,password=LTRIM(UPPER(@password))
,email=LTRIM(UPPER(@email))
,emailStatus=@emailStatus
,dateModified=@dateNow
WHERE user_id = @userId

IF @@error = 0
	BEGIN
  		COMMIT TRAN TRAN_updUserInfoLogin
    	RETURN 0
  	END
ELSE
	BEGIN
		ROLLBACK TRAN TRAN_updUserInfoLogin
		RETURN 99
	END
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoLogin TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoLogin') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoLogin >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoLogin >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoLogin','unchained'
go
