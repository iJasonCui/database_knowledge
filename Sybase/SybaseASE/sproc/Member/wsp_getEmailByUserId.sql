IF OBJECT_ID('dbo.wsp_getEmailByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getEmailByUserId
    IF OBJECT_ID('dbo.wsp_getEmailByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getEmailByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getEmailByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  Apr 26 2002
**   Description:  Select columns from user_info for a given user_id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getEmailByUserId
@user_id INT
AS

BEGIN
	SELECT email
	,signup_adcode
	FROM user_info
	WHERE user_id = @user_id
END 
 
go
GRANT EXECUTE ON dbo.wsp_getEmailByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getEmailByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getEmailByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getEmailByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getEmailByUserId','unchained'
go
