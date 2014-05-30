IF OBJECT_ID('dbo.wsp_savePurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_savePurchase
    IF OBJECT_ID('dbo.wsp_savePurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_savePurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_savePurchase >>>'
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
CREATE PROCEDURE dbo.wsp_savePurchase
   @userId                    NUMERIC(12,0),
   @xactionId                 INT,
   @xactionTypeId             TINYINT,
   @purchaseTypeId            TINYINT,
   @cost                      NUMERIC(10,2),
   @tax                       NUMERIC(10,2),
   @costUSD                   NUMERIC(5,2),
   @taxUSD                    NUMERIC(5,2),
   @purchaseOfferDetailId     SMALLINT,
   @subscriptionOfferDetailId SMALLINT,
   @billingLocationId         SMALLINT,
   @currencyId                TINYINT,
   @creditCardId              INT,
   @paymentNumber             VARCHAR(40),
   @cardProcessor             CHAR(1)

AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   BEGIN TRAN TRAN_savePurchase
   INSERT INTO Purchase(xactionId,
                        purchaseTypeId,
                        billingLocationId,
                        purchaseOfferDetailId,
                        subscriptionOfferDetailId,
                        currencyId,
                        cost,
                        costUSD,
                        tax,
                        taxUSD,
                        userId,
                        dateCreated,
                        creditCardId,
                        cardProcessor,
                        paymentNumber,
                        xactionTypeId)
   VALUES(@xactionId,
          @purchaseTypeId,
          @billingLocationId,
          @purchaseOfferDetailId,
          @subscriptionOfferDetailId,
          @currencyId,
          @cost,
          @costUSD,
          @tax,
          @taxUSD,
          @userId,
          @dateNowGMT,
          @creditCardId,
          @cardProcessor,
          @paymentNumber,
          @xactionTypeId)

   IF (@@error = 0)
      BEGIN
         IF (@creditCardId > 0)
            BEGIN
               UPDATE CreditCard 
                  SET dateLastUsed = @dateNowGMT 
                WHERE creditCardId = @creditCardId

               IF (@@error != 0)
                  BEGIN
                     ROLLBACK TRAN TRAN_savePurchase
                     RETURN 98
                  END
            END

         COMMIT TRAN TRAN_savePurchase
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_savePurchase
         RETURN 96
      END
END
go

IF OBJECT_ID('dbo.wsp_savePurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_savePurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_savePurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_savePurchase TO web
go

