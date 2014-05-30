IF OBJECT_ID('dbo.wsp_updCvvPassedFlagByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCvvPassedFlagByCardId
    IF OBJECT_ID('dbo.wsp_updCvvPassedFlagByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCvvPassedFlagByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCvvPassedFlagByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Aug 2, 2005
**   Description:  Update cvvPassedFlag by cardId
**
** REVISION(S):
**   Author:  Mike Stairs
**   Date:    Feb 27, 2006
**   Description: also update dateLastUsed column
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updCvvPassedFlagByCardId
     @creditCardId      int
    ,@cvvPassedFlag     CHAR(1)
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
    BEGIN TRAN TRAN_updCvvPassedFlagByCardId
        UPDATE CreditCard
           SET cvvPassedFlag = @cvvPassedFlag
              ,dateModified = @GetDateGMT
              ,dateLastUsed = @GetDateGMT
         WHERE creditCardId = @creditCardId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updCvvPassedFlagByCardId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updCvvPassedFlagByCardId
            RETURN 99
        END
END

go
IF OBJECT_ID('dbo.wsp_updCvvPassedFlagByCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updCvvPassedFlagByCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCvvPassedFlagByCardId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updCvvPassedFlagByCardId','unchained'
go
GRANT EXECUTE ON dbo.wsp_updCvvPassedFlagByCardId TO web
go
