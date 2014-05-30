IF OBJECT_ID('dbo.wsp_delUserAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delUserAccount
    IF OBJECT_ID('dbo.wsp_delUserAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delUserAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delUserAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  deletes all user account info
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delUserAccount
@userId            NUMERIC(12,0)
AS

BEGIN TRAN TRAN_delUserAccount

DELETE FROM UserAccount WHERE userId=@userId

IF @@error = 0
BEGIN
   COMMIT TRAN TRAN_delUserAccount
   RETURN 0
END
ELSE
BEGIN
   ROLLBACK TRAN TRAN_delUserAccount
   RETURN 98
END
go
IF OBJECT_ID('dbo.wsp_delUserAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delUserAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delUserAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_delUserAccount TO web
go

