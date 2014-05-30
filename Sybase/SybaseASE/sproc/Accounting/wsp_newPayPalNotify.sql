IF OBJECT_ID('dbo.wsp_newPayPalNotify') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPayPalNotify
    IF OBJECT_ID('dbo.wsp_newPayPalNotify') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPayPalNotify >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPayPalNotify >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Inserts row into PayPalNotify
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPayPalNotify
 @paymentNumber      VARCHAR(17)
,@paymentType        VARCHAR(63)
,@paymentStatus      VARCHAR(9)
,@paymentDate        VARCHAR(30)
,@paymentAmount      VARCHAR(7)
,@feeAmount          VARCHAR(7)
,@currencyCode       VARCHAR(3)
,@invoiceNumber      VARCHAR(19)
,@receiverId         VARCHAR(17)
,@receiverEmail      VARCHAR(127)
,@payerId            VARCHAR(17)
,@payerEmail         VARCHAR(127)
,@recurringProfileId VARCHAR(14)
,@profileStatus      VARCHAR(14)
,@nextPaymentDate    VARCHAR(30)
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM PayPalNotify WHERE paymentNumber = @paymentNumber)
    BEGIN
	    RETURN 99
    END 

BEGIN TRAN TRAN_newPayPalNotify
    INSERT INTO PayPalNotify (
         paymentNumber
        ,paymentType
        ,paymentStatus
        ,paymentDate
        ,paymentAmount
        ,feeAmount
        ,currencyCode
        ,invoiceNumber
        ,receiverId
        ,receiverEmail
        ,payerId
        ,payerEmail
        ,recurringProfileId
        ,profileStatus
        ,nextPaymentDate
        ,dateCreated
    )
    VALUES (
         @paymentNumber
        ,@paymentType
        ,@paymentStatus
        ,@paymentDate
        ,@paymentAmount
        ,@feeAmount
        ,@currencyCode
        ,@invoiceNumber
        ,@receiverId
        ,@receiverEmail
        ,@payerId
        ,@payerEmail
        ,@recurringProfileId
        ,@profileStatus
        ,@nextPaymentDate
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_newPayPalNotify
            RETURN 99
        END

    COMMIT TRAN TRAN_newPayPalNotify
    RETURN 0
go

GRANT EXECUTE ON dbo.wsp_newPayPalNotify TO web
go

IF OBJECT_ID('dbo.wsp_newPayPalNotify') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPayPalNotify >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPayPalNotify >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPayPalNotify','unchained'
go
