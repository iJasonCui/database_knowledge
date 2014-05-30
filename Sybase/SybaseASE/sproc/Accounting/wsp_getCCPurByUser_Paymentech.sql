IF OBJECT_ID('dbo.wsp_getCCPurByUser_Paymentech') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCCPurByUser_Paymentech
    IF OBJECT_ID('dbo.wsp_getCCPurByUser_Paymentech') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCCPurByUser_Paymentech >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCCPurByUser_Paymentech >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         June 3, 2005
**   Description:  Returns all credit card purchases for the given user id (made through Paymentech).
**
**   Author:       Andy Tran
**   Date:         February, 2008
**   Description:  added encodedCardId
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCCPurByUser_Paymentech
 @userId NUMERIC(12,0)
AS

BEGIN

    SELECT
    request.userId,
    request.actionCode,
    request.merchantId,
    request.xactionId,
    request.cardNumber,
    request.cardExpiryMonth,
    request.cardExpiryYear,
    request.cardType,
    request.cardHolderName,
    request.amount,
    request.userStreet,
    request.userCity,
    request.userState,
    request.userPostalCode,
    request.userCountryCode,
    request.dateCreated,
    response.responseCode,
    response.approvalCode,
    response.avsResponseCode,
    response.securityResponseCode,
    ctran.CCTranStatusId,
    response.dateCreated,
    request.encodedCardId

    FROM PaymentechRequest request, PaymentechResponse response, CreditCardTransaction ctran
    WHERE request.userId = @userId
    AND response.xactionId = request.xactionId AND request.xactionId *= ctran.xactionId
    AND response.dateCreated = (SELECT MIN(res2.dateCreated) 
								FROM PaymentechResponse res2 
								WHERE res2.xactionId = request.xactionId)

    RETURN @@error

END 
go
GRANT EXECUTE ON dbo.wsp_getCCPurByUser_Paymentech TO web
go
IF OBJECT_ID('dbo.wsp_getCCPurByUser_Paymentech') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCCPurByUser_Paymentech >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCCPurByUser_Paymentech >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCCPurByUser_Paymentech','unchained'
go
