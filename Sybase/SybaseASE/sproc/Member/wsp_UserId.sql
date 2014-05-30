IF OBJECT_ID('dbo.wsp_UserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_UserId
    IF OBJECT_ID('dbo.wsp_UserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_UserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_UserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga
**   Date:  July 9 2002
**   Description:  Generation of userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_UserId @userId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_UserId
    UPDATE UserId
    SET userId = userId + 1

    IF @@error = 0
        BEGIN
            SELECT @userId = userId
            FROM UserId
            COMMIT TRAN TRAN_wsp_UserId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_UserId
		  RETURN 99
        END
 
go
GRANT EXECUTE ON dbo.wsp_UserId TO web
go
IF OBJECT_ID('dbo.wsp_UserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_UserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_UserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_UserId','unchained'
go
