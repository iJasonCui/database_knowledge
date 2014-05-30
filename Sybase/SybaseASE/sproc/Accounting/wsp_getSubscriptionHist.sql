
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 17, 2004
**   Description:  retrieves UserAccount subscription history for the specified user
**
**
** REVISION(S):
**   Author: Marc Henderson
**   Date: December 8, 2004
**   Description: Update this to also retrieve card info now that cardId was added to UserSubscriptionAccount table
**
******************************************************************************/

IF OBJECT_ID('dbo.wsp_getSubscriptionHist') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSubscriptionHist
    IF OBJECT_ID('dbo.wsp_getSubscriptionHist') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubscriptionHist >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubscriptionHist >>>'
END
go

CREATE PROCEDURE dbo.wsp_getSubscriptionHist
 @userId NUMERIC(12,0)
,@dateModified DATETIME
AS


SELECT            
   usah.subscriptionOfferDetailId,
   usah.subscriptionStatus,
   usah.autoRenew,
   usah.subscriptionEndDate,
   usah.dateModified,                 
   usah.cancelCodeMask,
   usah.userCancelReason,
   usah.cardId,
   cc.cardNickname
FROM UserSubscriptionAccountHistory usah, CreditCard cc
WHERE usah.cardId = cc.creditCardId
AND usah.userId = @userId AND usah.dateModified > @dateModified
ORDER BY dateModified

RETURN @@error

go
GRANT EXECUTE ON dbo.wsp_getSubscriptionHist TO web
go
IF OBJECT_ID('dbo.wsp_getSubscriptionHist') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubscriptionHist >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubscriptionHist >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSubscriptionHist','unchained'
go
