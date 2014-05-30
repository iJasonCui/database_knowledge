IF OBJECT_ID('dbo.wsp_getCardIdByCCNumUsedSub') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub
    IF OBJECT_ID('dbo.wsp_getCardIdByCCNumUsedSub') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Marc Henderson
**   Date:         January 25 2005
**   Description:  retrieves cardId for the specified cardNumber
**
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub
 @encodedCardNum VARCHAR(64)
AS

BEGIN
    SELECT cardId 
      FROM SubscriptionTransaction 
     WHERE cardId IN (SELECT creditCardId FROM CreditCard WHERE encodedCardNum = @encodedCardNum)
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardIdByCCNumUsedSub TO web
go

IF OBJECT_ID('dbo.wsp_getCardIdByCCNumUsedSub') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardIdByCCNumUsedSub >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardIdByCCNumUsedSub','unchained'
go
