IF OBJECT_ID('dbo.wsp_saveGuestEmailStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveGuestEmailStatus
    IF OBJECT_ID('dbo.wsp_saveGuestEmailStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveGuestEmailStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveGuestEmailStatus >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  November 9 2006
**   Description:  save GuestEmailStatus data
**
** REVISION(S):
**   Author: 
**   Date:
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_saveGuestEmailStatus
    @email          VARCHAR(129),
    @spamFlag       CHAR(1),
    @bounceBackFlag CHAR(1)
AS

DECLARE @dateNow DATETIME,
        @return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF (@return != 0)
BEGIN
    RETURN @return
END

IF EXISTS(SELECT 1 FROM GuestEmailStatus WHERE email = @email) 
    BEGIN
        BEGIN TRAN TRAN_saveGuestEmailStatus
        UPDATE GuestEmailStatus 
           SET spamFlag       = @spamFlag,
               bounceBackFlag = @bounceBackFlag, 
               dateModified   = @dateNow
         WHERE email = @email

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveGuestEmailStatus
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveGuestEmailStatus
                RETURN 99
            END
    END
ELSE
    BEGIN  
        BEGIN TRAN TRAN_saveGuestEmailStatus
        INSERT GuestEmailStatus(email,
                                spamFlag,
                                bounceBackFlag,
                                dateCreated,
                                dateModified)
        VALUES(@email,
               @spamFlag,
               @bounceBackFlag,
               @dateNow,
               @dateNow)

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveGuestEmailStatus
                RETURN 0
            END 
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveGuestEmailStatus
                RETURN 98
            END
    END
go

GRANT EXECUTE ON dbo.wsp_saveGuestEmailStatus TO web
go

IF OBJECT_ID('dbo.wsp_saveGuestEmailStatus') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveGuestEmailStatus >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveGuestEmailStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveGuestEmailStatus','unchained'
go
