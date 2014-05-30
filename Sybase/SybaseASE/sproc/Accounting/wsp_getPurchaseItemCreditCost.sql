IF OBJECT_ID('dbo.wsp_getPurchaseItemCreditCost') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPurchaseItemCreditCost
    IF OBJECT_ID('dbo.wsp_getPurchaseItemCreditCost') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPurchaseItemCreditCost >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPurchaseItemCreditCost >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Jeff Yang 
**   Date:         September 2009
**   Description:  Retrieve purchase credit item cost .
**
******************************************************************************/
CREATE PROCEDURE wsp_getPurchaseItemCreditCost
 @xactionId     NUMERIC(12, 0)
,@offerDetailId SMALLINT
AS

   SELECT cost = 
            CASE p.purchaseOfferDetailId
               WHEN null THEN pd.cost
               ELSE p.cost
            END
         ,tax = 
            CASE p.purchaseOfferDetailId
               WHEN null THEN pd.tax
               ELSE p.tax
            END
      FROM Purchase p, PurchaseCreditDetail pd
     WHERE p.xactionId = @xactionId
       AND p.xactionId *= pd.xactionId

go

GRANT EXECUTE ON dbo.wsp_getPurchaseItemCreditCost TO web
go

IF OBJECT_ID('dbo.wsp_getPurchaseItemCreditCost') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPurchaseItemCreditCost >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPurchaseItemCreditCost >>>'
go
