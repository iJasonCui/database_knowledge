IF OBJECT_ID('dbo.wsp_chkProfileName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkProfileName
    IF OBJECT_ID('dbo.wsp_chkProfileName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkProfileName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkProfileName >>>'
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

CREATE PROCEDURE wsp_chkProfileName
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@myidentity CHAR(16)
,@userId NUMERIC(12,0) AS

  IF EXISTS
  (SELECT 1  FROM a_profile_dating
            WHERE user_id <> @userId
              AND myidentity = LTRIM(RTRIM(UPPER(@myidentity)))
  )

  BEGIN
    SELECT 1 AS returnVal
  END
  ELSE
  BEGIN
    SELECT 0 AS returnVal
  END
 
go
GRANT EXECUTE ON dbo.wsp_chkProfileName TO web
go
IF OBJECT_ID('dbo.wsp_chkProfileName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkProfileName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkProfileName >>>'
go
EXEC sp_procxmode 'dbo.wsp_chkProfileName','unchained'
go
