IF OBJECT_ID('dbo.wsp_savePurchaseDiscount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_savePurchaseDiscount
    IF OBJECT_ID('dbo.wsp_savePurchaseDiscount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_savePurchaseDiscount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_savePurchaseDiscount >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  January 16 2009 
**   Description:  save purchase discount 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_savePurchaseDiscount
   @xactionId      NUMERIC(12,0),
   @discountSeqId  NUMERIC(8,0), 
   @discountTypeId SMALLINT,
   @discountCode   VARCHAR(50),
   @discountAmt    NUMERIC(10,2),
   @discountAmtUSD NUMERIC(10,2),
   @offerDetailId  SMALLINT
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF (@xactionId <= 0)
      BEGIN
         RETURN 99 
      END

   IF NOT EXISTS(SELECT 1 FROM PurchaseDiscount
                  WHERE xactionId = @xactionId
                    AND discountSeqId = @discountSeqId)
      BEGIN
         BEGIN TRAN TRAN_purchaseDiscount
         INSERT INTO PurchaseDiscount(xactionId,
                                      discountSeqId,
                                      discountTypeId,
                                      discountCode,
                                      discountAmt,
                                      discountAmtUSD,
                                      dateCreated,
                                      offerDetailId)
         VALUES(@xactionId,
                @discountSeqId,
                @discountTypeId,
                @discountCode,
                @discountAmt,
                @discountAmtUSD,
                @dateNowGMT,
                @offerDetailId)

        IF (@@error = 0)
           BEGIN
              COMMIT TRAN TRAN_purchaseDiscount
           END
        ELSE
           BEGIN
              ROLLBACK TRAN TRAN_purchaseDiscount
              RETURN 98
           END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_savePurchaseDiscount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_savePurchaseDiscount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_savePurchaseDiscount >>>'
go

GRANT EXECUTE ON dbo.wsp_savePurchaseDiscount TO web
go

