IF OBJECT_ID('dbo.wsp_updUserInfoOnholdCity') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserInfoOnholdCity
    IF OBJECT_ID('dbo.wsp_updUserInfoOnholdCity') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserInfoOnholdCity >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserInfoOnholdCity >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 20 2002
**   Description:  Update onhold_city column of user_info by user_id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updUserInfoOnholdCity
 @onholdCity    CHAR(1)
,@userId        NUMERIC(12,0)
AS

BEGIN TRAN TRAN_updUserInfoOnholdCity

    UPDATE user_info SET
    onhold_city = @onholdCity
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUserInfoOnholdCity
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUserInfoOnholdCity
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updUserInfoOnholdCity TO web
go
IF OBJECT_ID('dbo.wsp_updUserInfoOnholdCity') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserInfoOnholdCity >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserInfoOnholdCity >>>'
go
EXEC sp_procxmode 'dbo.wsp_updUserInfoOnholdCity','unchained'
go
