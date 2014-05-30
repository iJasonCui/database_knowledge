IF OBJECT_ID('dbo.wsp_getPurchaseItemCost') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPurchaseItemCost
    IF OBJECT_ID('dbo.wsp_getPurchaseItemCost') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPurchaseItemCost >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPurchaseItemCost >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         September 2009
**   Description:  Retrieve purchase item cost (including upsell).
**
** REVISION(S): 
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_getPurchaseItemCost
 @xactionId     NUMERIC(12, 0)
,@offerDetailId SMALLINT
AS

DECLARE
 @cost NUMERIC(10, 2)
,@tax  NUMERIC(10, 2)
,@oid  SMALLINT

IF EXISTS(SELECT 1 FROM Purchase WHERE xactionId = @xactionId)
    BEGIN
        SELECT @cost = cost
              ,@tax = tax
              ,@oid = (CASE purchaseOfferDetailId WHEN NULL THEN subscriptionOfferDetailId ELSE purchaseOfferDetailId END) 
          FROM Purchase
         WHERE xactionId = @xactionId

        IF (@oid IS NULL OR @oid != @offerDetailId)
            BEGIN
                IF EXISTS(SELECT 1 FROM PurchaseSubscriptionDetail WHERE xactionId = @xactionId AND subscriptionOfferDetailId = @offerDetailId)
                    BEGIN
                        SELECT @cost = cost
                              ,@tax = tax
                           FROM PurchaseSubscriptionDetail
                          WHERE xactionId = @xactionId
                            AND subscriptionOfferDetailId = @offerDetailId
                    END
            END

        SELECT @cost, @tax
        RETURN @@error
    END
go

GRANT EXECUTE ON dbo.wsp_getPurchaseItemCost TO web
go

IF OBJECT_ID('dbo.wsp_getPurchaseItemCost') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPurchaseItemCost >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPurchaseItemCost >>>'
go
