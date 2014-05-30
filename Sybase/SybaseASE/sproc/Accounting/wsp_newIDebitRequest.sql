IF OBJECT_ID('dbo.wsp_newIDebitRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newIDebitRequest
    IF OBJECT_ID('dbo.wsp_newIDebitRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newIDebitRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newIDebitRequest >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 2006
**   Description: Inserts row into IDebitRequest
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newIDebitRequest
     @userId       NUMERIC(12,0)
    ,@xactionId    NUMERIC(12,0)
    ,@totalAmount  NUMERIC(12,0)
    ,@currencyCode CHAR(3)
AS
DECLARE
 @return      INT
,@dateCreated DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newIDebitRequest
    INSERT INTO IDebitRequest (
         userId
        ,xactionId
        ,totalAmount
        ,currencyCode
        ,dateCreated
    )
    VALUES (
         @userId
        ,@xactionId
        ,@totalAmount
        ,@currencyCode
        ,@dateCreated
    )

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_newIDebitRequest
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_newIDebitRequest
            RETURN 99
        END
go

GRANT EXECUTE ON dbo.wsp_newIDebitRequest TO web
go

IF OBJECT_ID('dbo.wsp_newIDebitRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newIDebitRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newIDebitRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_newIDebitRequest','unchained'
go
