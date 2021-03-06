IF OBJECT_ID('dbo.wsp_getCCPurByUser_JetPay') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCCPurByUser_JetPay
    IF OBJECT_ID('dbo.wsp_getCCPurByUser_JetPay') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCCPurByUser_JetPay >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCCPurByUser_JetPay >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author: Slobodan Kandic
**   Date: July 15, 2003
**   Description: Returns all credit card purchases for the given user id (made through JetPay).
**   This includes 'SALE' and 'AUTHONLY' records
**
** REVISION(S):
**   Author: Andy Tran
**   Date: Nov. 19, 2003
**   Description: Returns all credit card transactions, including 'VOID', 'CREDIT'
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCCPurByUser_JetPay
 @userId NUMERIC(12,0)
AS

BEGIN

    SELECT
    request.userId,
    request.transactionType,
    request.merchantId,
    request.transactionId,
    request.approval,
    request.password,
    request.orderNumber,
    request.cardNumber,
    request.cvv2,
    request.cardExpMonth,
    request.cardExpYear,
    request.cardType,
    request.ach,
    request.accountNumber,
    request.aba,
    request.checkNumber,
    request.cardName,
    request.dispositionType,
    request.totalAmount,
    request.feeAmount,
    request.taxAmount,
    request.billingAddress,
    request.billingCity,
    request.billingStateProv,
    request.billingPostalCode,
    request.billingCountry,
    request.billingPhone,
    request.email,
    request.userIPAddr,
    request.userHost,
    request.udField1,
    request.udField2,
    request.udField3,
    request.actionCode,
    request.dateCreated,

    response.actionCode response_actionCode,
    response.approval response_approval,
    response.addressMatch response_addressMatch,
    response.zipMatch response_zipMatch,
    response.avs response_avs,
    response.responseText response_responseText,
    response.errMsg response_errMsg,
    response.lastEvent response_lastEvent,
    response.dateCreated response_dateCreated

    FROM JetPayRequest request, JetPayResponse response
    WHERE request.userId = @userId
    AND response.transactionId = request.transactionId 
    AND response.dateCreated = (SELECT MIN(res2.dateCreated) 
								FROM JetPayResponse res2 
								WHERE res2.transactionId = request.transactionId)

    RETURN @@error

END 
go
GRANT EXECUTE ON dbo.wsp_getCCPurByUser_JetPay TO web
go
IF OBJECT_ID('dbo.wsp_getCCPurByUser_JetPay') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCCPurByUser_JetPay >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCCPurByUser_JetPay >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCCPurByUser_JetPay','unchained'
go
