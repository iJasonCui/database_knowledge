IF OBJECT_ID('dbo.wsp_getBadCreditCardByNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCreditCardByNumber
    IF OBJECT_ID('dbo.wsp_getBadCreditCardByNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCreditCardByNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCreditCardByNumber >>>'
END
go
	
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         November 21, 2003
**   Description:  retrieves all bad credit cards for a given card number
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
	
CREATE PROCEDURE dbo.wsp_getBadCreditCardByNumber
@cardNum VARCHAR(64)
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
     AND cc.cardNum = @cardNum
     ORDER BY cc.nameOnCard
	
	 RETURN @@error
END
go
	
GRANT EXECUTE ON dbo.wsp_getBadCreditCardByNumber TO web
go
	
IF OBJECT_ID('dbo.wsp_getBadCreditCardByNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCreditCardByNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCreditCardByNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_getBadCreditCardByNumber','unchained'
go
