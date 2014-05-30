IF OBJECT_ID('dbo.wsp_getOfferDetailsByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOfferDetailsByXactionId
    IF OBJECT_ID('dbo.wsp_getOfferDetailsByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOfferDetailsByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOfferDetailsByXactionId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November, 2005
**   Description: Returns all purchase offer details by this xactionId
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getOfferDetailsByXactionId
 @purchaseXactionId NUMERIC(12,0)
AS

BEGIN
    SELECT purchaseOfferDetailId, subscriptionOfferDetailId
      FROM Purchase
     WHERE xactionId = @purchaseXactionId
END

RETURN @@error
go

GRANT EXECUTE ON dbo.wsp_getOfferDetailsByXactionId TO web
go

IF OBJECT_ID('dbo.wsp_getOfferDetailsByXactionId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getOfferDetailsByXactionId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOfferDetailsByXactionId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getOfferDetailsByXactionId','unchained'
go
