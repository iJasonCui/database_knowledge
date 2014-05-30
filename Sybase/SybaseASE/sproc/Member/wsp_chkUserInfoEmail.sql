IF OBJECT_ID('dbo.wsp_chkUserInfoEmail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkUserInfoEmail
    IF OBJECT_ID('dbo.wsp_chkUserInfoEmail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkUserInfoEmail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkUserInfoEmail >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 4, 2002
**   Description: check if email exists in user_info table 
**
** REVISION(S):
**   Author:  Jeff Yang
**   Date:  September 23 2002
**   Description:  Added user_type in where clause
**
**   Author:  Jack Veiga 
**   Date:  May 2003
**   Description:  Added check of EmailReverify table
**
**   Author:  Andy Tran 
**   Date:  June 2008
**   Description:  Added returnVal as return value
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_chkUserInfoEmail
 @email CHAR(129)
,@userId NUMERIC(12,0) 

AS

IF NOT EXISTS (SELECT 1  FROM user_info
           WHERE status != 'J'
           AND user_id != @userId
           AND email = LTRIM(RTRIM(UPPER(@email)))
           AND user_type IN ('F', 'P'))

    BEGIN
		SELECT 0 AS returnVal
    END

ELSE

    BEGIN
        SELECT 1 AS returnVal
    END
 
go
GRANT EXECUTE ON dbo.wsp_chkUserInfoEmail TO web
go
IF OBJECT_ID('dbo.wsp_chkUserInfoEmail') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkUserInfoEmail >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkUserInfoEmail >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkUserInfoEmail','unchained'
go
