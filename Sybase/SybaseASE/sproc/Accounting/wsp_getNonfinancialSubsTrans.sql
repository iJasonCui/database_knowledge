
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  January 04, 2005
**   Description:  retrieves SubscriptionTransactions for a given userId (for a specified period of time.)
**
**
** REVISION(S):
**   Author:  Andy Tran 
**   Date:  September 2009
**   Description:  Add outer join for the case when the transaction is !CC
**
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/

IF OBJECT_ID('dbo.wsp_getNonfinancialSubsTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getNonfinancialSubsTrans
    IF OBJECT_ID('dbo.wsp_getNonfinancialSubsTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getNonfinancialSubsTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getNonfinancialSubsTrans >>>'
END
go

CREATE PROCEDURE dbo.wsp_getNonfinancialSubsTrans
 @userId NUMERIC(12,0)
,@dateCreated DATETIME
AS

SELECT
   snft.userId,
   snft.contentId,
   snft.subscriptionTypeId,
   snft.duration,
   snft.description,
   snft.dateCreated,
   snft.cardId,
   CASE WHEN snft.cardId < 0 THEN 'Non CC Trans' ELSE cc.cardNickname END
FROM SubscriptionNonfinancialTrans snft, CreditCard cc
WHERE snft.cardId *= cc.creditCardId
AND snft.userId = @userId
AND snft.dateCreated > @dateCreated
ORDER BY snft.dateCreated asc

RETURN @@error

go
GRANT EXECUTE ON dbo.wsp_getNonfinancialSubsTrans TO web
go
IF OBJECT_ID('dbo.wsp_getNonfinancialSubsTrans') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getNonfinancialSubsTrans >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getNonfinancialSubsTrans >>>'
go
EXEC sp_procxmode 'dbo.wsp_getNonfinancialSubsTrans','unchained'
go
