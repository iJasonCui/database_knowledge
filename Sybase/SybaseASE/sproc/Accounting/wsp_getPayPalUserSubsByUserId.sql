IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPayPalUserSubsByUserId
    IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPayPalUserSubsByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPayPalUserSubsByUserId >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Returns record in PayPalUserSubscription
**                by userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_getPayPalUserSubsByUserId
 @userId  NUMERIC(12,0)
AS

BEGIN
	SELECT recurringProfileId
	      ,subscriptionOfferDetailId
          ,subscriptionStatus
          ,subscriptionEndDate
      FROM PayPalUserSubscription
     WHERE userId = @userId
    
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getPayPalUserSubsByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPayPalUserSubsByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPayPalUserSubsByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPayPalUserSubsByUserId','unchained'
go
