IF OBJECT_ID('dbo.wsp_getPaymentechSettlementReq') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPaymentechSettlementReq
    IF OBJECT_ID('dbo.wsp_getPaymentechSettlementReq') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPaymentechSettlementReq >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPaymentechSettlementReq >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         May 27 2011
**   Description:  Retrieves Paymentech settlement record for the given xactionId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getPaymentechSettlementReq
 @xactionId NUMERIC(12,0)
AS
BEGIN  

    SELECT c.xactionId,
           p.userId,
           p.merchantId,
           p.actionCode,
           p.cardType,
           p.cardNumber,
           p.cardExpiryMonth,
           p.cardExpiryYear,
           p.amount,
           p.currencyCode,
           p.cardHolderName,
           p.userStreet,
           p.userCity,
           p.userState,
           p.userCountryCode,
           p.userPostalCode,
           r.responseCode,
           r.responseDate,
           r.approvalCode,
           r.avsResponseCode,
           p.cardIssueNumber,
           p.cardStartMonth,
           p.cardStartYear,
           p.encodedCardId,
           c.renewalFlag
      FROM CreditCardTransaction c, PaymentechRequest p, PaymentechResponse r
     WHERE c.xactionId = @xactionId
       AND c.xactionId = p.xactionId
       AND p.xactionId = r.xactionId
       AND c.CCTranStatusId = 3
       AND r.errorMessage IS NULL

   RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getPaymentechSettlementReq TO web
go

IF OBJECT_ID('dbo.wsp_getPaymentechSettlementReq') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPaymentechSettlementReq >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPaymentechSettlementReq >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPaymentechSettlementReq','unchained'
go
