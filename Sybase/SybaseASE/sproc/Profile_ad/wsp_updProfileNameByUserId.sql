IF OBJECT_ID('dbo.wsp_updProfileNameByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updProfileNameByUserId
    IF OBJECT_ID('dbo.wsp_updProfileNameByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updProfileNameByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updProfileNameByUserId >>>'
END
go
  /*************************************************************************
**
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  June 6 2002
**   Description:  Updates profile name for a given user id
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_updProfileNameByUserId
@userId numeric(12,0)
AS

BEGIN TRAN TRAN_updProfileNameByUserId

    UPDATE a_profile_dating SET
    myidentity = NULL
    ,approved='N'
    WHERE user_id = @userId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updProfileNameByUserId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updProfileNameByUserId
            RETURN 99
        END 
 
go
GRANT EXECUTE ON dbo.wsp_updProfileNameByUserId TO web
go
IF OBJECT_ID('dbo.wsp_updProfileNameByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updProfileNameByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updProfileNameByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updProfileNameByUserId','unchained'
go
