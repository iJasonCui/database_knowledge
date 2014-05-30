IF OBJECT_ID('dbo.wsp_newIDebitTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newIDebitTransaction
    IF OBJECT_ID('dbo.wsp_newIDebitTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newIDebitTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newIDebitTransaction >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Inserts row into IDebitTransaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newIDebitTransaction
     @xactionId           NUMERIC(12,0)
    ,@errorNumber         SMALLINT
    ,@errorDescription    VARCHAR(255)
    ,@transactionError    CHAR(1)
    ,@transactionApproved CHAR(1)
    ,@exactRespCode       CHAR(2)
    ,@exactRespMessage    VARCHAR(50)
    ,@bankRespCode        CHAR(3)
    ,@bankRespMessage     VARCHAR(80)
    ,@authorizationNumber VARCHAR(8)
AS
DECLARE
 @return      INT
,@dateCreated DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newIDebitTransaction
    INSERT INTO IDebitTransaction (
         xactionId
        ,errorNumber
        ,errorDescription
        ,transactionError
        ,transactionApproved
        ,exactRespCode
        ,exactRespMessage
        ,bankRespCode
        ,bankRespMessage
        ,authorizationNumber
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@errorNumber
        ,@errorDescription
        ,@transactionError
        ,@transactionApproved
        ,@exactRespCode
        ,@exactRespMessage
        ,@bankRespCode
        ,@bankRespMessage
        ,@authorizationNumber
        ,@dateCreated
    )

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newIDebitTransaction
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newIDebitTransaction
            RETURN 99
        END
go

GRANT EXECUTE ON dbo.wsp_newIDebitTransaction TO web
go

IF OBJECT_ID('dbo.wsp_newIDebitTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newIDebitTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newIDebitTransaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_newIDebitTransaction','unchained'
go
