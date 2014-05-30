IF OBJECT_ID('dbo.wsp_wcsUserInfoByCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsUserInfoByCity
    IF OBJECT_ID('dbo.wsp_wcsUserInfoByCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsUserInfoByCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsUserInfoByCity >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 26 2002
**   Description:  Retrieve user infomation given a partial city
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:   Sept 6, 2005
**   Description: force sity name to upper case
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_wcsUserInfoByCity
 @rowcount  INT
,@city   VARCHAR(24)
AS
SELECT @city = UPPER(@city)

BEGIN TRAN TRAN_wcsUserInfoByCity

  SET ROWCOUNT @rowcount

  SELECT user_id
  ,username
  ,city
  FROM user_info
  WHERE UPPER(city) LIKE @city
  ORDER BY user_id DESC
  AT ISOLATION READ UNCOMMITTED

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_wcsUserInfoByCity
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_wcsUserInfoByCity
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_wcsUserInfoByCity TO web
go
IF OBJECT_ID('dbo.wsp_wcsUserInfoByCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsUserInfoByCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsUserInfoByCity >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsUserInfoByCity','unchained'
go
