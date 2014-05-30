IF OBJECT_ID('dbo.wsp_updRealCardTypeByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updRealCardTypeByCardId
    IF OBJECT_ID('dbo.wsp_updRealCardTypeByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updRealCardTypeByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updRealCardTypeByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         July 13, 2010
**   Description:  Update realCardTypeId by cardId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updRealCardTypeByCardId
 @creditCardId INT
,@cardTypeId   SMALLINT
AS

DECLARE
 @return       INT
,@dateNow      DATETIME

EXEC @return = wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    BEGIN TRAN TRAN_updRealCardTypeByCardId
        UPDATE CreditCard
           SET realCardTypeId = @cardTypeId
              ,dateModified = @dateNow
              ,dateLastUsed = @dateNow
         WHERE creditCardId = @creditCardId

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_updRealCardTypeByCardId
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_updRealCardTypeByCardId
            RETURN 99
        END
END

go
IF OBJECT_ID('dbo.wsp_updRealCardTypeByCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updRealCardTypeByCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updRealCardTypeByCardId >>>'
go
EXEC sp_procxmode 'dbo.wsp_updRealCardTypeByCardId','unchained'
go
GRANT EXECUTE ON dbo.wsp_updRealCardTypeByCardId TO web
go
