IF OBJECT_ID('dbo.wsp_getCardIdByEncCardIdForSub') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub
    IF OBJECT_ID('dbo.wsp_getCardIdByEncCardIdForSub') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Retrieves card id for the specified encodedCardId
**                 previously used for subscription
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub
 @encodedCardId INT
AS

BEGIN
    SELECT cardId 
      FROM SubscriptionTransaction 
     WHERE cardId IN (SELECT creditCardId FROM CreditCard WHERE encodedCardId = @encodedCardId)
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardIdByEncCardIdForSub TO web
go

IF OBJECT_ID('dbo.wsp_getCardIdByEncCardIdForSub') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardIdByEncCardIdForSub >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardIdByEncCardIdForSub','unchained'
go
