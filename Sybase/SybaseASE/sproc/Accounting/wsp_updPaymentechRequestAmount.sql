IF OBJECT_ID('dbo.wsp_updPaymentechRequestAmount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPaymentechRequestAmount
    IF OBJECT_ID('dbo.wsp_updPaymentechRequestAmount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPaymentechRequestAmount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPaymentechRequestAmount >>>'
END
go
CREATE PROCEDURE wsp_updPaymentechRequestAmount
 @activityId     	NUMERIC(12,0)
,@amount            NUMERIC(10,0)
AS
DECLARE
 @return            INT

BEGIN TRAN TRAN_updPaymentechRequestAmt

UPDATE PaymentechRequest 
    SET amount = @amount
    WHERE xactionId = @activityId

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updPaymentechRequestAmt
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updPaymentechRequestAmt
        RETURN 99
    END

go
IF OBJECT_ID('dbo.wsp_updPaymentechRequestAmount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updPaymentechRequestAmount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updPaymentechRequestAmount >>>'
go
EXEC sp_procxmode 'dbo.wsp_updPaymentechRequestAmount','unchained'
go
GRANT EXECUTE ON dbo.wsp_updPaymentechRequestAmount TO web
go
