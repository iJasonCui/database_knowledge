IF OBJECT_ID('dbo.wsp_savePurchaseCreditDetail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_savePurchaseCreditDetail
    IF OBJECT_ID('dbo.wsp_savePurchaseCreditDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_savePurchaseCreditDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_savePurchaseCreditDetail >>>'
END
go

CREATE PROCEDURE dbo.wsp_savePurchaseCreditDetail
   @xactionId                 INT,
   @purchaseOfferDetailId     SMALLINT,
   @cost                      NUMERIC(10,2),
   @tax                       NUMERIC(10,2),
   @costUSD                   NUMERIC(5,2),
   @taxUSD                    NUMERIC(5,2)
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   IF (@xactionId <= 0)
      BEGIN
         RETURN 99 
      END

   BEGIN TRAN TRAN_purchaseCreditDetail
   INSERT INTO PurchaseCreditDetail(xactionId,
                                          purchaseOfferDetailId,
                                          cost,
                                          costUSD,
                                          tax,
                                          taxUSD,
                                          dateCreated)
   VALUES(@xactionId,
          @purchaseOfferDetailId,
          @cost,
          @costUSD,
          @tax,
          @taxUSD,
          @dateNowGMT)

   IF (@@error = 0)
      BEGIN
         COMMIT TRAN TRAN_purchaseCreditDetail 
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_purchaseCreditDetail 
         RETURN 98
      END
END
go

IF OBJECT_ID('dbo.wsp_savePurchaseCreditDetail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_savePurchaseCreditDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_savePurchaseCreditDetail >>>'
go

GRANT EXECUTE ON dbo.wsp_savePurchaseCreditDetail TO web
go

