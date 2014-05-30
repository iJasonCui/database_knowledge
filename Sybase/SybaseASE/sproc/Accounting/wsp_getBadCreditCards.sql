IF OBJECT_ID('dbo.wsp_getBadCreditCards') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCreditCards
    IF OBJECT_ID('dbo.wsp_getBadCreditCards') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCreditCards >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCreditCards >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Slobodan Kandic
**   Date:         Sept 29, 2003
**   Description:  retrieves all bad credit cards
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBadCreditCards
AS

BEGIN
    SELECT cc.creditCardId
          ,cc.userId
          ,cc.cardTypeId
          ,cc.cardNum
          ,cc.encodedCardNum
          ,cc.partialCardNum
          ,cc.cardExpiry
          ,cc.cardNickname
          ,cc.nameOnCard
          ,cc.address
          ,cc.city
          ,cc.country
          ,cc.countryArea
          ,cc.zipCode
          ,cc.status
          ,cc.cvv
          ,cc.dateModified
          ,cc.dateCreated
          ,bcc.reasonContentId
          ,bcc.reason
          ,bcc.status
          ,bcc.dateCreated
          ,bcc.dateModified		
      FROM CreditCard cc, BadCreditCard bcc
     WHERE cc.creditCardId = bcc.creditCardId
        ORDER BY 1

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getBadCreditCards TO web
go

IF OBJECT_ID('dbo.wsp_getBadCreditCards') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCreditCards >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCreditCards >>>'
go

EXEC sp_procxmode 'dbo.wsp_getBadCreditCards','unchained'
go
