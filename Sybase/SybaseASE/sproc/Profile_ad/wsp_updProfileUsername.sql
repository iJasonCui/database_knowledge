IF OBJECT_ID('dbo.wsp_updProfileUsername') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileUsername
    IF OBJECT_ID('dbo.wsp_updProfileUsername') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileUsername >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileUsername >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga,Jeff Yang
**   Date:  Oct 22, 2002
**   Description:  Updates show_prefs on profile
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE wsp_updProfileUsername
 @productCode   CHAR(1)
,@communityCode CHAR(1)
,@userId NUMERIC(12,0)
,@username CHAR(16)

AS

BEGIN TRAN TRAN_updUsername

    UPDATE a_profile_dating SET
    username = @username
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updUsername
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updUsername
            RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_updProfileUsername TO web
go
IF OBJECT_ID('dbo.wsp_updProfileUsername') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileUsername >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileUsername >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileUsername','unchained'
go
