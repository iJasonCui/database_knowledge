IF OBJECT_ID('dbo.wsp_updUserInfoGenderByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoGenderByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoGenderByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoGenderByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoGenderByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Update gender user info by user id
**
**   Author: Mike Stairs
**   Date: Oct 2005
**   Description: added dateModified to user_info
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoGenderByUserId
 @gender    CHAR(1)
,@userId    NUMERIC(12,0)
AS

DECLARE @dateNow DATETIME
DECLARE @return INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
  RETURN @return
END

BEGIN TRAN TRAN_updUserInfoGenderByUserId

UPDATE user_info SET
gender = @gender
,dateModified=@dateNow
WHERE user_id = @userId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoGenderByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoGenderByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoGenderByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoGenderByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoGenderByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoGenderByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoGenderByUserId','unchained'
go
