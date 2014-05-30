IF OBJECT_ID('dbo.wsp_newPayPalTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPayPalTransaction
    IF OBJECT_ID('dbo.wsp_newPayPalTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPayPalTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPayPalTransaction >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Inserts row into PayPalTransaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPayPalTransaction
 @xactionId     NUMERIC(12,0)
,@paymentNumber VARCHAR(17)
,@paymentType   VARCHAR(16)
,@paymentStatus VARCHAR(9)
,@paymentDate   VARCHAR(30)
,@paymentAmount VARCHAR(7)
,@feeAmount     VARCHAR(7)
,@currencyCode  VARCHAR(3)
,@pendingReason VARCHAR(14)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPayPalTransaction
    INSERT INTO PayPalTransaction (
         xactionId
        ,paymentNumber
        ,paymentType
        ,paymentStatus
        ,paymentDate
        ,paymentAmount
        ,feeAmount
        ,currencyCode
        ,pendingReason
        ,dateCreated
    )
    VALUES (
         @xactionId
        ,@paymentNumber
        ,@paymentType
        ,@paymentStatus
        ,@paymentDate
        ,@paymentAmount
        ,@feeAmount
        ,@currencyCode
        ,@pendingReason
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newPayPalTransaction
            RETURN 99
        END

    COMMIT TRAN TRAN_newPayPalTransaction
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newPayPalTransaction TO web
go

IF OBJECT_ID('dbo.wsp_newPayPalTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPayPalTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPayPalTransaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPayPalTransaction','unchained'
go
