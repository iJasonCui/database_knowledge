IF OBJECT_ID('dbo.wsp_XactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_XactionId
    IF OBJECT_ID('dbo.wsp_XactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_XactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_XactionId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 2003
**   Description:  Generation of XactionId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_XactionId @xactionId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_XactionId
    UPDATE XactionId
    SET xactionId = xactionId + 1

    IF @@error = 0
        BEGIN
            SELECT @xactionId = xactionId
            FROM XactionId
            COMMIT TRAN TRAN_wsp_XactionId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_XactionId
		  RETURN 99
        END 

go
GRANT EXECUTE ON dbo.wsp_XactionId TO web
go
IF OBJECT_ID('dbo.wsp_XactionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_XactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_XactionId >>>'
go

