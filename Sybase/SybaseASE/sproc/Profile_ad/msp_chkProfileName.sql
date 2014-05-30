IF OBJECT_ID('dbo.msp_chkProfileName') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.msp_chkProfileName
    IF OBJECT_ID('dbo.msp_chkProfileName') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.msp_chkProfileName >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.msp_chkProfileName >>>'
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

CREATE PROCEDURE msp_chkProfileName
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@myidentity CHAR(16)
,@userId NUMERIC(12,0) AS

  IF EXISTS
  (SELECT 1  FROM a_profile_dating
            WHERE user_id <> @userId
              AND myidentity = @myidentity
  )

  BEGIN
    SELECT 1
  END
  ELSE
  BEGIN
    SELECT 0
  END
 
go
GRANT EXECUTE ON dbo.msp_chkProfileName TO web
go
IF OBJECT_ID('dbo.msp_chkProfileName') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.msp_chkProfileName >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.msp_chkProfileName >>>'
go
EXEC sp_procxmode 'dbo.msp_chkProfileName','unchained'
go
