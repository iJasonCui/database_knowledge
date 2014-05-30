IF OBJECT_ID('dbo.wsp_getBadCardByNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCardByNumber
    IF OBJECT_ID('dbo.wsp_getBadCardByNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCardByNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCardByNumber >>>'
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
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**
**   Author:       Andy Tran
**   Date:         February, 2008
**   Description:  added encodedCardId
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBadCardByNumber
 @encodedCardNum VARCHAR(64)
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
     WHERE bcc.creditCardId = cc.creditCardId AND bcc.status='B'  AND cc.encodedCardNum = @encodedCardNum
  ORDER BY cc.nameOnCard

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getBadCardByNumber TO web
go

IF OBJECT_ID('dbo.wsp_getBadCardByNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCardByNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCardByNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_getBadCardByNumber','unchained'
go
