IF OBJECT_ID('dbo.wsp_newPaymentechRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPaymentechRequest
    IF OBJECT_ID('dbo.wsp_newPaymentechRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPaymentechRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPaymentechRequest >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        March 18 2005 
**   Description: Inserts row into PaymentechRequest
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_newPaymentechRequest
 @userId            NUMERIC(12,0)
,@xactionId         NUMERIC(12,0)
,@merchantId        CHAR(10)
,@actionCode        CHAR(2)
,@cardType          CHAR(2)
,@cardNumber        VARCHAR(64)
,@cardExpiryMonth   CHAR(2)
,@cardExpiryYear    CHAR(2)
,@amount            NUMERIC(10,0)
,@currencyCode      CHAR(3)
,@cardHolderName    VARCHAR(30)
,@userStreet        VARCHAR(30)
,@userCity          VARCHAR(20)
,@userState         CHAR(2)
,@userCountryCode   CHAR(2)
,@userPostalCode    VARCHAR(10)
,@cardSecurityValue VARCHAR(4)
,@cardSecurityPresence CHAR(1)
,@cardIssueNumber   CHAR(2)
,@cardStartMonth    CHAR(2)
,@cardStartYear     CHAR(2)
AS
DECLARE
 @return            INT
,@dateCreated       DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateCreated OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_newPaymentechRequest

INSERT INTO PaymentechRequest (
     userId
    ,xactionId
    ,merchantId
    ,actionCode
    ,cardType
    ,cardNumber
    ,cardExpiryMonth
    ,cardExpiryYear
    ,amount
    ,currencyCode
    ,cardHolderName
    ,userStreet
    ,userCity
    ,userState
    ,userCountryCode
    ,userPostalCode
    ,cardSecurityValue
    ,cardSecurityPresence
    ,cardIssueNumber
    ,cardStartMonth
    ,cardStartYear
    ,dateCreated
)
VALUES (
     @userId
    ,@xactionId
    ,@merchantId
    ,@actionCode
    ,@cardType
    ,@cardNumber
    ,@cardExpiryMonth
    ,@cardExpiryYear
    ,@amount
    ,@currencyCode
    ,@cardHolderName
    ,@userStreet
    ,@userCity
    ,@userState
    ,@userCountryCode
    ,@userPostalCode
    ,@cardSecurityValue
    ,@cardSecurityPresence
    ,@cardIssueNumber
    ,@cardStartMonth
    ,@cardStartYear
    ,@dateCreated
)

IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_newPaymentechRequest
        RETURN 0
    END
ELSE
    BEGIN
        ROLLBACK TRAN TRAN_newPaymentechRequest
        RETURN 99
    END
go

GRANT EXECUTE ON dbo.wsp_newPaymentechRequest TO web
go

IF OBJECT_ID('dbo.wsp_newPaymentechRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPaymentechRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPaymentechRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_newPaymentechRequest','unchained'
go
