IF OBJECT_ID('dbo.wsp_getSubPurchaseCost') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSubPurchaseCost
    IF OBJECT_ID('dbo.wsp_getSubPurchaseCost') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubPurchaseCost >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubPurchaseCost >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Yan Liu
**   Date:         April 2008
**   Description:  Retrieve Subscripiton Purchase Cost.
**
** REVISION(S): 
**   Author:     Jeff Yang 
**   Date:        July 22 2008 
**   Description: Return tax as well for refund
**
******************************************************************************/
CREATE PROCEDURE wsp_getSubPurchaseCost
   @xactionId                 NUMERIC(12, 0),
   @subscriptionOfferDetailId SMALLINT
AS

BEGIN
   DECLARE @cost        NUMERIC(10, 2)
   DECLARE @tax         NUMERIC(10, 2)
   DECLARE @subDetailId SMALLINT

   IF EXISTS(SELECT 1 FROM Purchase WHERE xactionId = @xactionId)
      BEGIN
         SELECT @cost = cost,
                @tax = tax,
                @subDetailId = subscriptionOfferDetailId 
           FROM Purchase
          WHERE xactionId = @xactionId

         IF (@subDetailId IS NULL) 
            BEGIN
               IF EXISTS(SELECT 1 FROM PurchaseSubscriptionDetail 
                          WHERE xactionId = @xactionId
                            AND subscriptionOfferDetailId = @subscriptionOfferDetailId)
                  BEGIN
                     SELECT @cost = cost, @tax = tax
                       FROM PurchaseSubscriptionDetail
                      WHERE xactionId = @xactionId
                        AND subscriptionOfferDetailId = @subscriptionOfferDetailId

                     SELECT @cost, @tax
                  END
            END
         ELSE
            BEGIN
               IF (@subscriptionOfferDetailId = @subDetailId) 
                  BEGIN
                     SELECT @cost, @tax
                  END 
            END
      END
  
   RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getSubPurchaseCost TO web
go

IF OBJECT_ID('dbo.wsp_getSubPurchaseCost') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubPurchaseCost >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubPurchaseCost >>>'
go
