IF OBJECT_ID('dbo.wsp_cntHourlySalesByType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntHourlySalesByType
    IF OBJECT_ID('dbo.wsp_cntHourlySalesByType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntHourlySalesByType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntHourlySalesByType >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:  
**
** REVISION(S):
**   Author: Yan L. and Jason C.
**   Date:   Jul 21 2004
**   Description: 6-- purchase; 
**
** REVISION(S):
**   Author: Yadira Genoves 
**   Date:  Aug 19 2008
**   Description: Selects Lavalife's sales. productId = (0 -- Lavalife, 1 -- Prime, 2 -- 50+)
******************************************************************************/

CREATE PROCEDURE wsp_cntHourlySalesByType
 @fromDate DATETIME
,@toDate   DATETIME
AS

SELECT sum(purchase.costUSD) as cost, purchase.purchaseTypeId as type  
 FROM BillingLocation billingLoc, Purchase purchase
WHERE billingLoc.billingLocationId = purchase.billingLocationId 
 AND billingLoc.productId = 0
 AND dateCreated >= @fromDate 
 AND dateCreated < @toDate 
 AND xactionTypeId IN (6, 31, 32) 
GROUP BY purchaseTypeId
 
RETURN @@error
go
GRANT EXECUTE ON dbo.wsp_cntHourlySalesByType TO web
go
IF OBJECT_ID('dbo.wsp_cntHourlySalesByType') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntHourlySalesByType >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntHourlySalesByType >>>'
go
