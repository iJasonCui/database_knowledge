IF OBJECT_ID('dbo.wsp_getPurchaseByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPurchaseByDate
    IF OBJECT_ID('dbo.wsp_getPurchaseByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPurchaseByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPurchaseByDate >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu/Jack Veiga
**   Date:  November 2003
**   Description:  
**
** REVISION(S):
**   Author:  Yan Liu	
**   Date:  April 5 2005
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getPurchaseByDate
    @startDate DATETIME,
    @endDate   DATETIME
AS

BEGIN
    SELECT xactionTypeId,
           xactionId,
           userId,
           creditCardId,
           refXactionId,
           purchaseTypeId,
           purchaseOfferDetailId,
           currencyId,
           costUSD,
           taxUSD,
           cost,
           tax, 
           subscriptionOfferDetailId, 
           dateCreated
      FROM Purchase
     WHERE dateCreated >= @startDate
       AND dateCreated <  @endDate
    AT ISOLATION READ UNCOMMITTED
END

RETURN @@error
go

GRANT EXECUTE ON dbo.wsp_getPurchaseByDate TO web
go

IF OBJECT_ID('dbo.wsp_getPurchaseByDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPurchaseByDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPurchaseByDate >>>'
go
