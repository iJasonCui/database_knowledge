IF OBJECT_ID('dbo.wsp_newPayPalRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPayPalRequest
    IF OBJECT_ID('dbo.wsp_newPayPalRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPayPalRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPayPalRequest >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Inserts row into PayPalRequest
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPayPalRequest
 @xactionId    NUMERIC(12,0)
,@userId       NUMERIC(12,0)
,@totalAmount  VARCHAR(7)
,@currencyCode CHAR(3)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPayPalRequest
    INSERT INTO PayPalRequest (
         xactionId
        ,userId
        ,totalAmount
        ,currencyCode
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@userId
        ,@totalAmount
        ,@currencyCode
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newPayPalRequest
            RETURN 99
        END

    COMMIT TRAN TRAN_newPayPalRequest
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newPayPalRequest TO web
go

IF OBJECT_ID('dbo.wsp_newPayPalRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPayPalRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPayPalRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPayPalRequest','unchained'
go
