IF OBJECT_ID('dbo.wsp_updProfilePictByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfilePictByUserId
    IF OBJECT_ID('dbo.wsp_updProfilePictByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfilePictByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfilePictByUserId >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 19 2002
**   Description:  Updates profile pict for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfilePictByUserId
 @productCode char(1)
,@communityCode char(1)
,@userId numeric(12,0)
,@pict char(1) = null
AS

BEGIN TRAN TRAN_updProfilePictByUserId

    UPDATE a_profile_dating
    SET pict = @pict
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfilePictByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfilePictByUserId
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfilePictByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfilePictByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfilePictByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfilePictByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfilePictByUserId','unchained'
go
