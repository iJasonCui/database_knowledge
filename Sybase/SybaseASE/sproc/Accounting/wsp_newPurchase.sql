IF OBJECT_ID('dbo.wsp_newPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newPurchase
    IF OBJECT_ID('dbo.wsp_newPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newPurchase >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  January 13 2009 
**   Description:  save purchase 
**
** REVISION(S):
**   Author:  Andy Tran
**   Date:  April 2010
**   Description:  added taxCountryId and taxJurisdictionId
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newPurchase
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
   @cardProcessor             CHAR(1),
   @discountFlag              CHAR(1),
   @taxCountryId              SMALLINT,
   @taxJurisdictionId         INT
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   BEGIN TRAN TRAN_newPurchase
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
                        xactionTypeId,
                        discountFlag,
                        taxCountryId,
                        taxJurisdictionId)
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
          @xactionTypeId,
          @discountFlag,
          @taxCountryId,
          @taxJurisdictionId)

   IF (@@error = 0)
      BEGIN
         IF (@creditCardId > 0)
            BEGIN
               UPDATE CreditCard 
                  SET dateLastUsed = @dateNowGMT 
                WHERE creditCardId = @creditCardId

               IF (@@error != 0)
                  BEGIN
                     ROLLBACK TRAN TRAN_newPurchase
                     RETURN 98
                  END
            END

         COMMIT TRAN TRAN_newPurchase
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_newPurchase
         RETURN 96
      END
END
go

IF OBJECT_ID('dbo.wsp_newPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_newPurchase TO web
go

