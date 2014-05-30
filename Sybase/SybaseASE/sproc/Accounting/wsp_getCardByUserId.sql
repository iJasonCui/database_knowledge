IF OBJECT_ID('dbo.wsp_getCardByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardByUserId
    IF OBJECT_ID('dbo.wsp_getCardByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs  
**   Date:         Fab 23, 2004
**   Description:  retrieves card list for the specified userId
**
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

CREATE PROCEDURE dbo.wsp_getCardByUserId
@userId NUMERIC(12,0)
AS

BEGIN
    SELECT 
           creditCardId
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
     WHERE CreditCard.userId = @userId
       AND CreditCard.creditCardId *= DebitCard.cardId
       AND CreditCard.creditCardId *= BankCard.cardId
    ORDER BY status ASC, dateLastUsed DESC
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getCardByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardByUserId','unchained'
go
