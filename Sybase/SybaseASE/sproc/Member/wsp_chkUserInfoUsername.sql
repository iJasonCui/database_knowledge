IF OBJECT_ID('dbo.wsp_chkUserInfoUsername') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkUserInfoUsername
    IF OBJECT_ID('dbo.wsp_chkUserInfoUsername') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkUserInfoUsername >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkUserInfoUsername >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 4, 2002
**   Description:  Check if username exists in user_info table 
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  June 2008
**   Description:  Added returnVal as return value
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_chkUserInfoUsername
 @username CHAR(16)
,@userId NUMERIC(12,0) AS

  IF EXISTS
  (SELECT 1  FROM user_info
            WHERE status <> 'J'
              AND user_id <> @userId
              AND username = LTRIM(RTRIM(UPPER(@username)))
  )

  BEGIN
    SELECT 1 AS returnVal
  END
  ELSE
  BEGIN
    SELECT 0 AS returnVal
  END
 
go
GRANT EXECUTE ON dbo.wsp_chkUserInfoUsername TO web
go
IF OBJECT_ID('dbo.wsp_chkUserInfoUsername') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkUserInfoUsername >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkUserInfoUsername >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkUserInfoUsername','unchained'
go
