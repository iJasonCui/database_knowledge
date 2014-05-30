IF OBJECT_ID('dbo.wsp_getOptimalPaymentsRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOptimalPaymentsRequest
    IF OBJECT_ID('dbo.wsp_getOptimalPaymentsRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOptimalPaymentsRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOptimalPaymentsRequest >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Feb 24 2011
**   Description:  Retrieves OptimalPaymentsRequest record for the given xactionId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getOptimalPaymentsRequest
 @xactionId NUMERIC(12,0)
,@actionCode VARCHAR(20)
AS
BEGIN  

    SELECT customerId,
           merchantId,
           merchantRefNum,
           cardNumber,
           cardType,
           cardExpiryMonth,
           cardExpiryYear,
           amount,
           currencyCode,
           cardHolderName,
           userStreet,
           userCity,
           userState,
           userCountryCode,
           userPostalCode,
           cardSecurityValue,
           cardIssueNumber,
           cardStartMonth,
           cardStartYear,
           dateCreated,
           cardSecurityPresence,
           authAmount,
           encodedCardId,
           customerIP,
           email
      FROM OptimalPaymentsRequest
     WHERE activityId = @xactionId
       AND actionCode = @actionCode

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getOptimalPaymentsRequest TO web
go

IF OBJECT_ID('dbo.wsp_getOptimalPaymentsRequest') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getOptimalPaymentsRequest >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOptimalPaymentsRequest >>>'
go

EXEC sp_procxmode 'dbo.wsp_getOptimalPaymentsRequest','unchained'
go
