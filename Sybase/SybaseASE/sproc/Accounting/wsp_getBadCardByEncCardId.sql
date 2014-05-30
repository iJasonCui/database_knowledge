IF OBJECT_ID('dbo.wsp_getBadCardByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCardByEncCardId
    IF OBJECT_ID('dbo.wsp_getBadCardByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCardByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCardByEncCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  retrieves all bad credit cards for a given card number
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBadCardByEncCardId
 @encodedCardId INT
AS

BEGIN
    SELECT cc.creditCardId
          ,cc.userId
          ,cc.cardTypeId
          ,cc.encodedCardNum
          ,cc.partialCardNum
          ,cc.nameOnCard
          ,bcc.reasonContentId
          ,bcc.reason
          ,cc.encodedCardId
      FROM BadCreditCard bcc, CreditCard cc
     WHERE bcc.creditCardId = cc.creditCardId AND bcc.status='B'  AND cc.encodedCardId = @encodedCardId
  ORDER BY cc.nameOnCard

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getBadCardByEncCardId TO web
go

IF OBJECT_ID('dbo.wsp_getBadCardByEncCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCardByEncCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCardByEncCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getBadCardByEncCardId','unchained'
go
