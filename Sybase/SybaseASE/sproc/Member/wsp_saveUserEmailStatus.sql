IF OBJECT_ID('dbo.wsp_saveUserEmailStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveUserEmailStatus
    IF OBJECT_ID('dbo.wsp_saveUserEmailStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveUserEmailStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveUserEmailStatus >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Yan L 
**   Date:  November 9 2006
**   Description:  save UserEmailStatus data
**
** REVISION(S):
**   Author: 
**   Date:
**   Description: 
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_saveUserEmailStatus
    @userId         NUMERIC(12,0),
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

IF EXISTS(SELECT 1 FROM UserEmailStatus WHERE userId = @userId) 
    BEGIN
        BEGIN TRAN TRAN_saveUserEmailStatus
        UPDATE UserEmailStatus 
           SET spamFlag       = @spamFlag,
               bounceBackFlag = @bounceBackFlag, 
               dateModified   = @dateNow
         WHERE userId = @userId

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveUserEmailStatus
                RETURN 0
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveUserEmailStatus
                RETURN 99
            END
    END
ELSE
    BEGIN  
        BEGIN TRAN TRAN_saveUserEmailStatus
        INSERT UserEmailStatus(userId,
                               spamFlag,
                               bounceBackFlag,
                               dateCreated,
                               dateModified)
        VALUES(@userId,
               @spamFlag,
               @bounceBackFlag,
               @dateNow,
               @dateNow)

        IF (@@error = 0)
            BEGIN
                COMMIT TRAN TRAN_saveUserEmailStatus
                RETURN 0
            END 
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_saveUserEmailStatus
                RETURN 98
            END
    END
go

GRANT EXECUTE ON dbo.wsp_saveUserEmailStatus TO web
go

IF OBJECT_ID('dbo.wsp_saveUserEmailStatus') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_saveUserEmailStatus >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveUserEmailStatus >>>'
go

EXEC sp_procxmode 'dbo.wsp_saveUserEmailStatus','unchained'
go
