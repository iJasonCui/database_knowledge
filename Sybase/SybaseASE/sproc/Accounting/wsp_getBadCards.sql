IF OBJECT_ID('dbo.wsp_getBadCards') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCards
    IF OBJECT_ID('dbo.wsp_getBadCards') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCards >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCards >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Feb 23, 2004
**   Description:  retrieves all bad cards
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         February, 2008
**   Description:  added encodedCardId
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBadCards
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
      WHERE bcc.creditCardId = cc.creditCardId AND bcc.status = 'B'
      ORDER BY cc.userId

    RETURN @@error
END

go
IF OBJECT_ID('dbo.wsp_getBadCards') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCards >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCards >>>'
go
EXEC sp_procxmode 'dbo.wsp_getBadCards','unchained'
go
GRANT EXECUTE ON dbo.wsp_getBadCards TO web
go

