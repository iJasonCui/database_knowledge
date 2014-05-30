IF OBJECT_ID('dbo.msp_chkUserInfoUsername') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_chkUserInfoUsername
    IF OBJECT_ID('dbo.msp_chkUserInfoUsername') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_chkUserInfoUsername >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_chkUserInfoUsername >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Jeff Yang
**   Date:  June 4, 2002
**   Description: check if username exists in user_info table 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  msp_chkUserInfoUsername
 @username CHAR(16)
,@userId NUMERIC(12,0) AS

  IF EXISTS
  (SELECT 1  FROM user_info
            WHERE status <> 'J'
              AND user_id <> @userId
              AND username = @username
  )

  BEGIN
    SELECT 1
  END
  ELSE
  BEGIN
    SELECT 0
  END
 
go
GRANT EXECUTE ON dbo.msp_chkUserInfoUsername TO web
go
IF OBJECT_ID('dbo.msp_chkUserInfoUsername') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_chkUserInfoUsername >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_chkUserInfoUsername >>>'
go
EXEC sp_procxmode 'dbo.msp_chkUserInfoUsername','unchained'
go
