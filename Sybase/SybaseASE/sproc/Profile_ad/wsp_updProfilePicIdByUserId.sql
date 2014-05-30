IF OBJECT_ID('dbo.wsp_updProfilePicIdByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfilePicIdByUserId
    IF OBJECT_ID('dbo.wsp_updProfilePicIdByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfilePicIdByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfilePicIdByUserId >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 19 2002
**   Description:  Updates profile picture id for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfilePicIdByUserId
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@pictureId int = null
AS

BEGIN TRAN TRAN_updProfilePicIdByUsrId

    UPDATE a_dating
    SET picture_id = @pictureId
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfilePicIdByUsrId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfilePicIdByUsrId
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfilePicIdByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfilePicIdByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfilePicIdByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfilePicIdByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfilePicIdByUserId','unchained'
go
