IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByProfId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPayPalUserSubsByProfId
    IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByProfId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPayPalUserSubsByProfId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPayPalUserSubsByProfId >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        July 2009 
**   Description: Returns record in PayPalUserSubscription
**                by recurringProfileId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_getPayPalUserSubsByProfId
 @recurringProfileId  VARCHAR(14)
AS

BEGIN
	SELECT userId
	      ,subscriptionOfferDetailId
          ,subscriptionStatus
          ,subscriptionEndDate
      FROM PayPalUserSubscription
     WHERE recurringProfileId = @recurringProfileId
    
    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_getPayPalUserSubsByProfId TO web
go

IF OBJECT_ID('dbo.wsp_getPayPalUserSubsByProfId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPayPalUserSubsByProfId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPayPalUserSubsByProfId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPayPalUserSubsByProfId','unchained'
go
