IF OBJECT_ID('dbo.wsp_delUserEmailStatusByUId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delUserEmailStatusByUId
    IF OBJECT_ID('dbo.wsp_delUserEmailStatusByUId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delUserEmailStatusByUId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delUserEmailStatusByUId >>>'
END
go
/******************************************************************************
 **
 ** CREATION:
 **   Author:  Yan L 
 **   Date:  November 13 2006
 **   Description:  Delete UserEmailStatus data
 **
 ** REVISION(S):
 **   Author: 
 **   Date:
 **   Description: 
 **
******************************************************************************/

CREATE PROCEDURE dbo.wsp_delUserEmailStatusByUId
    @userId NUMERIC(12, 0)
AS

BEGIN
    IF EXISTS(SELECT 1 FROM UserEmailStatus WHERE userId = @userId)
    BEGIN
        BEGIN TRAN TRAN_delUserEmailStatus

        DELETE FROM UserEmailStatus
         WHERE userId = @userId

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_delUserEmailStatus
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_delUserEmailStatus
                RETURN 99
            END
    END

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_delUserEmailStatusByUId TO web
go

IF OBJECT_ID('dbo.wsp_delUserEmailStatusByUId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delUserEmailStatusByUId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delUserEmailStatusByUId >>>'
go

EXEC sp_procxmode 'dbo.wsp_delUserEmailStatusByUId','unchained'
go
