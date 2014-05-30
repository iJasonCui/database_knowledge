IF OBJECT_ID('dbo.wsp_updAvsPassedFlagByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updAvsPassedFlagByCardId
    IF OBJECT_ID('dbo.wsp_updAvsPassedFlagByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updAvsPassedFlagByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updAvsPassedFlagByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2011
**   Description:  Update avsPassedFlag by cardId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updAvsPassedFlagByCardId
     @creditCardId      int
    ,@avsPassedFlag     CHAR(1)
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
    BEGIN TRAN TRAN_updAvsPassedFlagByCardId
        UPDATE CreditCard
           SET avsPassedFlag = @avsPassedFlag
              ,dateModified = @GetDateGMT
              ,dateLastUsed = @GetDateGMT
         WHERE creditCardId = @creditCardId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updAvsPassedFlagByCardId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updAvsPassedFlagByCardId
            RETURN 99
        END
END

go
IF OBJECT_ID('dbo.wsp_updAvsPassedFlagByCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updAvsPassedFlagByCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updAvsPassedFlagByCardId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updAvsPassedFlagByCardId','unchained'
go
GRANT EXECUTE ON dbo.wsp_updAvsPassedFlagByCardId TO web
go
