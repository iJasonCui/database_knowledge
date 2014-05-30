IF OBJECT_ID('dbo.wsp_getCardByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardByCardId
    IF OBJECT_ID('dbo.wsp_getCardByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Feb 23, 2004
**   Description:  retrieves card for the specified cardId
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         June 30, 2004
**   Description:  added debit card Solo/Maestro
**
**   Author:       Mike Stairs
**   Date:         Aug 2, 2005
**   Description:  added cvvPassedFlag
**
**   Author:       Andy Tran
**   Date:         February, 2008
**   Description:  added encodedCardId
**
**   Author:       Andy Tran
**   Date:         February, 2011
**   Description:  added avsPassedFlag
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCardByCardId
@creditCardId int
AS

BEGIN
    SELECT 
          CreditCard.userId
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
          ,bankCode
          ,bankCity
          ,bankAddress
          ,bankName
          ,bankAccount
          ,status
          ,cvv
          ,CreditCard.dateModified
          ,CreditCard.dateCreated
          ,issueNumber
          ,cardStartDate
          ,ISNULL(cvvPassedFlag,'Y') as cvvPassedFlag
          ,encodedCardId
          ,dateLastUsed
          ,realCardTypeId
          ,ISNULL(avsPassedFlag,'Y') as avsPassedFlag
      FROM CreditCard, DebitCard, BankCard
     WHERE CreditCard.creditCardId = @creditCardId
       AND CreditCard.creditCardId *= DebitCard.cardId
       AND CreditCard.creditCardId *= BankCard.cardId
         
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardByCardId TO web
go

IF OBJECT_ID('dbo.wsp_getCardByCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardByCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardByCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardByCardId','unchained'
go
