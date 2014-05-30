IF OBJECT_ID('dbo.wsp_savePurchaseSubDetail') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_savePurchaseSubDetail
    IF OBJECT_ID('dbo.wsp_savePurchaseSubDetail') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_savePurchaseSubDetail >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_savePurchaseSubDetail >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 11 2008 
**   Description:  save purchase 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_savePurchaseSubDetail
   @xactionId                 INT,
   @subscriptionOfferDetailId SMALLINT,
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

   BEGIN TRAN TRAN_purchaseSubDetail
   INSERT INTO PurchaseSubscriptionDetail(xactionId,
                                          subscriptionOfferDetailId,
                                          cost,
                                          costUSD,
                                          tax,
                                          taxUSD,
                                          dateCreated)
   VALUES(@xactionId,
          @subscriptionOfferDetailId,
          @cost,
          @costUSD,
          @tax,
          @taxUSD,
          @dateNowGMT)

   IF (@@error = 0)
      BEGIN
         COMMIT TRAN TRAN_purchaseSubDetail 
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_purchaseSubDetail 
         RETURN 98
      END
END
go

IF OBJECT_ID('dbo.wsp_savePurchaseSubDetail') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_savePurchaseSubDetail >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_savePurchaseSubDetail >>>'
go

GRANT EXECUTE ON dbo.wsp_savePurchaseSubDetail TO web
go

