IF OBJECT_ID('dbo.wsp_getJetPayReqByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getJetPayReqByXactionId
    IF OBJECT_ID('dbo.wsp_getJetPayReqByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getJetPayReqByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getJetPayReqByXactionId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          Sep. 14, 2004
**   Description:   Returns JetPay request for the given transactionId
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getJetPayReqByXactionId
 @transactionId CHAR(18)
AS

BEGIN
    SELECT userId,
           transactionType,
           merchantId,
           approval,
           password,
           orderNumber,
           cardNumber,
           cvv2,
           cardExpMonth,
           cardExpYear,
           cardType,
           ach,
           accountNumber,
           aba,
           checkNumber,
           cardName,
           dispositionType,
           totalAmount,
           feeAmount,
           taxAmount,
           billingAddress,
           billingCity,
           billingStateProv,
           billingPostalCode,
           billingCountry,
           billingPhone,
           email,
           userIPAddr,
           userHost,
           udField1,
           udField2,
           udField3,
           actionCode,
           dateCreated 
    FROM JetPayRequest
    WHERE transactionId = @transactionId

    RETURN @@error
END 
go
GRANT EXECUTE ON dbo.wsp_getJetPayReqByXactionId TO web
go
IF OBJECT_ID('dbo.wsp_getJetPayReqByXactionId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getJetPayReqByXactionId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getJetPayReqByXactionId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getJetPayReqByXactionId','unchained'
go
