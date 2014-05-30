IF OBJECT_ID('dbo.wsp_delGuestEmailStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delGuestEmailStatus
    IF OBJECT_ID('dbo.wsp_delGuestEmailStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delGuestEmailStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delGuestEmailStatus >>>'
END
go
/******************************************************************************
 **
 ** CREATION:
 **   Author:  Yan L 
 **   Date:  November 13 2006
 **   Description:  Delete GuestEmailStatus data
 **
 ** REVISION(S):
 **   Author: 
 **   Date:
 **   Description: 
 **
******************************************************************************/

CREATE PROCEDURE dbo.wsp_delGuestEmailStatus
    @email VARCHAR(129)  
AS

BEGIN
    IF EXISTS(SELECT 1 FROM GuestEmailStatus WHERE email = @email)
    BEGIN
        BEGIN TRAN TRAN_delGuestEmailStatus

        DELETE FROM GuestEmailStatus
         WHERE email = @email 

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_delGuestEmailStatus
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_delGuestEmailStatus
                RETURN 99
            END
    END

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_delGuestEmailStatus TO web
go

IF OBJECT_ID('dbo.wsp_delGuestEmailStatus') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delGuestEmailStatus >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delGuestEmailStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_delGuestEmailStatus','unchained'
go
