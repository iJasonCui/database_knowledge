IF OBJECT_ID('dbo.wsp_chkUserInfoUsernameEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkUserInfoUsernameEmail
    IF OBJECT_ID('dbo.wsp_chkUserInfoUsernameEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkUserInfoUsernameEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkUserInfoUsernameEmail >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  July 18 2002
**   Description: Check if username and email exists in user_info table 
**
** REVISION(S):
**   Author:  Jeff Yang
**   Date:  September 23 2002
**   Description:  Added user_type in where clause
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_chkUserInfoUsernameEmail
 @usernameExistsFlag	BIT OUTPUT
,@emailExistsFlag		BIT OUTPUT
,@userId 				NUMERIC(12,0) 
,@username 				VARCHAR(16)
,@email					VARCHAR(126)

AS

IF EXISTS (SELECT 1  FROM user_info WHERE status != 'J' AND user_id != @userId AND username = @username AND user_type in ('F','P'))

	BEGIN
		SELECT @usernameExistsFlag = 1
	END
ELSE
	BEGIN
		SELECT @usernameExistsFlag = 0
	END

IF NOT EXISTS (SELECT 1  FROM user_info
           WHERE status != 'J'
           AND user_id != @userId
           AND email = @email
           AND user_type IN ('F', 'P'))

    BEGIN
        SELECT @emailExistsFlag = 0
    END

ELSE

    BEGIN
        SELECT @emailExistsFlag = 1
    END
 
go
GRANT EXECUTE ON dbo.wsp_chkUserInfoUsernameEmail TO web
go
IF OBJECT_ID('dbo.wsp_chkUserInfoUsernameEmail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkUserInfoUsernameEmail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkUserInfoUsernameEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkUserInfoUsernameEmail','unchained'
go
