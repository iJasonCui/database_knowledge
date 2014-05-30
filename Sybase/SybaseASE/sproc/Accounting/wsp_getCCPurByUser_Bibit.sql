IF OBJECT_ID('dbo.wsp_getCCPurByUser_Bibit') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCCPurByUser_Bibit
    IF OBJECT_ID('dbo.wsp_getCCPurByUser_Bibit') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCCPurByUser_Bibit >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCCPurByUser_Bibit >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          February 12, 2004
**   Description:   Returns all credit card purchases for the given user id (made through Bibit).
**                  This includes 'SALE' and 'AUTHONLY' records
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCCPurByUser_Bibit
 @userId NUMERIC(12,0)
AS

BEGIN

    SELECT
        req.transactionType                 req_transactionType,
        req.merchantCode                    req_merchantCode,
        req.transactionId                   req_transactionId,
        req.userId                          req_userId,
        cur.currencyCode                    req_currencyCode,
        cur.precisionDigits                 req_currencyExponent,
        req.amount                          req_amount,
        loc.contentText                     req_cardName,
        ccd.cardNum                         req_cardNumber,
        substring(ccd.cardExpiry, 1, 2)     req_cardExpiryMonth,
        substring(ccd.cardExpiry, 3, 2)     req_cardExpiryYear,
        ccd.nameOnCard                      req_cardHolderName,
        ccd.cvv                             req_cvc,
        req.ipAddress                       req_ipAddress,
        req.sessionId                       req_sessionId,

        res.referenceId                     res_referenceId,
        res.actionCode                      res_actionCode,
        res.responseText                    res_responseText,
        res.avsResponseText                 res_avsResponseText,
        res.cvcResponseText                 res_cvcResponseText,
        res.errorMessage                    res_errorMessage,
        res.dateCreated                     res_dateCreated

    FROM BibitRequest req, BibitResponse res, Currency cur, CreditCard ccd, LocaleContent loc, CardType cty

    WHERE req.userId = @userId
    AND req.transactionId = res.transactionId
    AND req.currencyId = cur.currencyId
    AND req.cardId = ccd.creditCardId
    AND ccd.cardTypeId = cty.cardTypeId
    AND cty.contentId = loc.contentId
    AND res.dateCreated = (SELECT MIN(dateCreated) FROM BibitResponse WHERE transactionId = req.transactionId)

    RETURN @@error

END 
go
GRANT EXECUTE ON dbo.wsp_getCCPurByUser_Bibit TO web
go
IF OBJECT_ID('dbo.wsp_getCCPurByUser_Bibit') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCCPurByUser_Bibit >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCCPurByUser_Bibit >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCCPurByUser_Bibit','unchained'
go
