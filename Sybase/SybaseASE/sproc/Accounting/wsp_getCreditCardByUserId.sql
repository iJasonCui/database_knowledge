IF OBJECT_ID('dbo.wsp_getCreditCardByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditCardByUserId
    IF OBJECT_ID('dbo.wsp_getCreditCardByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditCardByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditCardByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Sept 9, 2003
**   Description:  retrieves credit card for the specified cardId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCreditCardByUserId
@userId NUMERIC(12,0)
AS

BEGIN
    SELECT creditCardId
          ,cardTypeId
          ,cardNum
          ,encodedCardNum
          ,partialCardNum
          ,cardExpiry
          ,cardNickname
          ,nameOnCard
          ,address
          ,city
          ,country
          ,countryArea
          ,zipCode
          ,status
          ,cvv
          ,dateModified
          ,dateCreated
      FROM CreditCard
     WHERE userId = @userId
    ORDER BY creditCardId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCreditCardByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getCreditCardByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditCardByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditCardByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCreditCardByUserId','unchained'
go
