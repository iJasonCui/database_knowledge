IF OBJECT_ID('dbo.wsp_getPayPalUserSubsRenewal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPayPalUserSubsRenewal
    IF OBJECT_ID('dbo.wsp_getPayPalUserSubsRenewal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPayPalUserSubsRenewal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPayPalUserSubsRenewal >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        Oct 2009 
**   Description: Returns records in PayPalUserSubscription
**                which are to be renewed
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_getPayPalUserSubsRenewal
AS

DECLARE
 @dateNow DATETIME
,@return  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
	SELECT  userId
	       ,recurringProfileId
	       ,subscriptionOfferDetailId
          ,subscriptionStatus
          ,subscriptionEndDate
      FROM PayPalUserSubscription
     WHERE subscriptionStatus = 'A'
       AND subscriptionEndDate  = dateadd(dd,1,@dateNow)
       --AND DATEDIFF(dd, @dateNow, subscriptionEndDate) = 1

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getPayPalUserSubsRenewal TO web
go

IF OBJECT_ID('dbo.wsp_getPayPalUserSubsRenewal') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPayPalUserSubsRenewal >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPayPalUserSubsRenewal >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPayPalUserSubsRenewal','unchained'
go
