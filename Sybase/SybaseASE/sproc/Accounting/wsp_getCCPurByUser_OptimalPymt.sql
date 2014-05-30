IF OBJECT_ID('dbo.wsp_getCCPurByUser_OptimalPymt') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt
    IF OBJECT_ID('dbo.wsp_getCCPurByUser_OptimalPymt') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2011
**   Description:  Returns all credit card purchases for the given user id (made through OptimalPayments).
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt
 @userId NUMERIC(12,0)
AS

BEGIN

    SELECT
    request.customerId,
    request.actionCode,
    request.merchantId,
    request.activityId,
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
    response.code,
    response.authCode,
    response.avsResponse,
    response.cvdResponse,
    ctran.CCTranStatusId,
    response.dateCreated,
    request.encodedCardId,
    request.customerIP,
    request.email

    FROM OptimalPaymentsRequest request(index XPKOptimalPaymentsRequest), OptimalPaymentsResponse response, CreditCardTransaction ctran
    WHERE request.customerId = @userId
    AND response.activityId = request.activityId
    AND response.merchantRefNum = request.merchantRefNum
    AND request.activityId *= ctran.xactionId
    AND response.dateCreated = (SELECT MIN(res2.dateCreated) 
								FROM OptimalPaymentsResponse res2 
								WHERE res2.activityId = request.activityId)

    RETURN @@error

END 
go
GRANT EXECUTE ON dbo.wsp_getCCPurByUser_OptimalPymt TO web
go
IF OBJECT_ID('dbo.wsp_getCCPurByUser_OptimalPymt') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCCPurByUser_OptimalPymt >>>'
go
EXEC sp_procxmode 'dbo.wsp_getCCPurByUser_OptimalPymt','unchained'
go
