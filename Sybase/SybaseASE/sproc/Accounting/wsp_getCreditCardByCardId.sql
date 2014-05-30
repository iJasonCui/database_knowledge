IF OBJECT_ID('dbo.wsp_getCreditCardByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditCardByCardId
    IF OBJECT_ID('dbo.wsp_getCreditCardByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditCardByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditCardByCardId >>>'
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

CREATE PROCEDURE dbo.wsp_getCreditCardByCardId
@creditCardId int
AS

BEGIN
    SELECT userId
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
     WHERE creditCardId = @creditCardId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCreditCardByCardId TO web
go

IF OBJECT_ID('dbo.wsp_getCreditCardByCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditCardByCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditCardByCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCreditCardByCardId','unchained'
go
