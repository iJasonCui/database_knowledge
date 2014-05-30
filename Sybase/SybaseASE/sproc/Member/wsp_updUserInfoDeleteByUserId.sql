IF OBJECT_ID('dbo.wsp_updUserInfoDeleteByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoDeleteByUserId
    IF OBJECT_ID('dbo.wsp_updUserInfoDeleteByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoDeleteByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoDeleteByUserId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Yahya Kola
**   Date:  March 12 2004
**   Description:  Log deletion reason when member deletening the account
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoDeleteByUserId
@userId        NUMERIC(12,0)
,@deleteReasonId INT 
AS

BEGIN TRAN TRAN_updUserInfoDeleteByUserId
INSERT INTO UserInfoDelete (userId,deleteReasonId,dateCreated)
                    VALUES (@userId,@deleteReasonId, getdate())


IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updUserInfoDeleteByUserId
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updUserInfoDeleteByUserId
        RETURN 99
    END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoDeleteByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoDeleteByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.updUserInfoDeleteByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoDeleteByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoDeleteByUserId','unchained'
go
