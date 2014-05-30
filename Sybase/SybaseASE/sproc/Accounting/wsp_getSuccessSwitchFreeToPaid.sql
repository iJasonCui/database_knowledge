
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  December 8, 2004
**   Description:  
**
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/

IF OBJECT_ID('dbo.wsp_getSuccessSwitchFreeToPaid') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid
    IF OBJECT_ID('dbo.wsp_getSuccessSwitchFreeToPaid') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid >>>'
END
go

CREATE PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid
 @userId NUMERIC(12,0)
,@subscriptionTypeId smallint
AS

select 
usa.userId
from UserSubscriptionAccount usa, SubscriptionTransaction st, SubscriptionOffer so, SubscriptionOfferDetail sod
where usa.userId = st.userId
and sod.subscriptionOfferId = so.subscriptionOfferId
and sod.contentId = st.contentId
and st.userId = @userId
and st.subscriptionTypeId = 1
and usa.autoRenew = 'Y'
and sod.cost = 0
and (select count(xactionId) from SubscriptionTransaction where userId = @userId and subscriptionTypeId = @subscriptionTypeId) = 2
and (select count(xactionId) from SubscriptionTransaction where userId = @userId and subscriptionTypeId = @subscriptionTypeId and duration = 0) = 0

RETURN @@error

go
GRANT EXECUTE ON dbo.wsp_getSuccessSwitchFreeToPaid TO web
go
IF OBJECT_ID('dbo.wsp_getSuccessSwitchFreeToPaid') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSuccessSwitchFreeToPaid >>>'
go
EXEC sp_procxmode 'dbo.wsp_getSuccessSwitchFreeToPaid','unchained'
go
