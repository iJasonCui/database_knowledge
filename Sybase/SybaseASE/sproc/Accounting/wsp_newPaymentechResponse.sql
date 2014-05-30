IF OBJECT_ID('dbo.wsp_newPaymentechResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPaymentechResponse
    IF OBJECT_ID('dbo.wsp_newPaymentechResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPaymentechResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPaymentechResponse >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        March 18 2005 
**   Description: Inserts row into PaymentechResponse
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPaymentechResponse
 @xactionId            NUMERIC(12,0)
,@responseCode         CHAR(3)
,@responseDate         CHAR(6)
,@approvalCode         CHAR(6)
,@avsResponseCode      CHAR(2)
,@securityResponseCode CHAR(1)
,@cardNumber           VARCHAR(64)
,@cardExpiryMonth      CHAR(2)
,@cardExpiryYear       CHAR(2)
,@cardType             CHAR(2)
,@recurringPaymentCode CHAR(2)
,@cavvResponseCode     CHAR(1)
,@amount               NUMERIC(10,0)
,@errorMessage         VARCHAR(255)
AS
DECLARE
 @return               INT
,@dateCreated          DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPaymentechResponse

INSERT INTO PaymentechResponse (
     xactionId
    ,responseCode
    ,responseDate
    ,approvalCode
    ,avsResponseCode
    ,securityResponseCode
    ,cardNumber
    ,cardExpiryMonth
    ,cardExpiryYear
    ,cardType
    ,recurringPaymentCode
    ,cavvResponseCode
    ,amount
    ,errorMessage
    ,dateCreated
)
VALUES (
     @xactionId
    ,@responseCode
    ,@responseDate
    ,@approvalCode
    ,@avsResponseCode
    ,@securityResponseCode
    ,@cardNumber
    ,@cardExpiryMonth
    ,@cardExpiryYear
    ,@cardType
    ,@recurringPaymentCode
    ,@cavvResponseCode
    ,@amount
    ,@errorMessage
    ,@dateCreated
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newPaymentechResponse
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newPaymentechResponse
        RETURN 99
    END
go

GRANT EXECUTE ON dbo.wsp_newPaymentechResponse TO web
go

IF OBJECT_ID('dbo.wsp_newPaymentechResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPaymentechResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPaymentechResponse >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPaymentechResponse','unchained'
go
