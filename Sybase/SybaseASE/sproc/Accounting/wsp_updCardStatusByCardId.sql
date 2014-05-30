IF OBJECT_ID('dbo.wsp_updCardStatusByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCardStatusByCardId
    IF OBJECT_ID('dbo.wsp_updCardStatusByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCardStatusByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCardStatusByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Sep 9, 2003
**   Description:  Update card status by cardId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updCardStatusByCardId
     @creditCardId      int
    ,@status            CHAR(1)
AS

DECLARE
 @return      INT
,@GetDateGMT  DATETIME

EXEC @return = wsp_GetDateGMT @GetDateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    BEGIN TRAN TRAN_updCardStatusByCardId
        UPDATE CreditCard
           SET status = @status
              ,dateModified = @GetDateGMT
         WHERE creditCardId = @creditCardId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updCardStatusByCardId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updCardStatusByCardId
            RETURN 99
        END
END
go

GRANT EXECUTE ON dbo.wsp_updCardStatusByCardId TO web
go

IF OBJECT_ID('dbo.wsp_updCardStatusByCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCardStatusByCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCardStatusByCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_updCardStatusByCardId','unchained'
go
