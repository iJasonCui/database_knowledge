IF OBJECT_ID('dbo.wsp_getBadCreditCardByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getBadCreditCardByCardId
    IF OBJECT_ID('dbo.wsp_getBadCreditCardByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getBadCreditCardByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getBadCreditCardByCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Sept 9, 2003
**   Description:  retrieves credit card for the specified creditCardId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getBadCreditCardByCardId
@creditCardId NUMERIC(12,0)
AS

BEGIN
    SELECT reasonContentId
          ,reason
          ,status
          ,dateModified
          ,dateCreated
      FROM BadCreditCard
     WHERE creditCardId = @creditCardId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getBadCreditCardByCardId TO web
go

IF OBJECT_ID('dbo.wsp_getBadCreditCardByCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getBadCreditCardByCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getBadCreditCardByCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getBadCreditCardByCardId','unchained'
go
