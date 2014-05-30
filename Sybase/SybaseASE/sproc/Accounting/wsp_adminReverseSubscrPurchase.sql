IF OBJECT_ID('dbo.wsp_adminReverseSubscrPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminReverseSubscrPurchase
    IF OBJECT_ID('dbo.wsp_adminReverseSubscrPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminReverseSubscrPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminReverseSubscrPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 26, 2004
**   Description:  reverses  subscription purchase for user
**
**
** REVISION(S):
**   Author: Marc Henderson
**   Date: February 02 2005
**   Description: fixed bugs - proc obviously never tested prior to this
**
**   Author: Mike Stairs
**   Date: July 7, 2005
**   Description: pass in card processor
**
**   Author: Andy Tran
**   Date: December, 2007
**   Description: negate duration - proc obviously never tested prior to this
**
**   Author: Yan Liu 
**   Date: April, 2008
**   Description: add subscriptioOfferDetailId 
**
**   Author: Andy Tran 
**   Date: April, 2010
**   Description: added taxCountryId and taxJurisdictionId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminReverseSubscrPurchase
   @userId           NUMERIC(12,0),
   @xactionId        NUMERIC(12,0),
   @refXactionId     NUMERIC(12,0),
   @contentId        SMALLINT,
   @xactionTypeId    TINYINT,
   @cardProcessor    CHAR(1),
   @adminUserId      INT,
   @adminNote        VARCHAR(255),
   @subOfferDetailId SMALLINT
AS

BEGIN
   DECLARE @return             INT,
           @dateNow            DATETIME,
           @cost               NUMERIC(10, 2),
           @costUSD            NUMERIC(5, 2),
           @tax                NUMERIC(10, 2),
           @taxUSD             NUMERIC(5, 2),
           @currencyId         TINYINT,
           @offerDetailId      SMALLINT,
           @purchaseTypeId     TINYINT,
           @billingLocationId  SMALLINT,
           @duration           SMALLINT,
           @creditCardId       INT,
           @subscriptionTypeId SMALLINT,
           @durationUnits      CHAR(1),
           @taxCountryId       SMALLINT,
           @taxJurisdictionId  INT

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF (@return != 0)
   BEGIN
      RETURN @return
   END

   SELECT @cost              = cost,
          @costUSD           = costUSD,
          @tax               = tax,
          @taxUSD            = taxUSD,
          @creditCardId      = creditCardId,
          @currencyId        = currencyId,
          @offerDetailId     = subscriptionOfferDetailId,
          @billingLocationId = billingLocationId,
          @purchaseTypeId    = purchaseTypeId,
          @taxCountryId      = taxCountryId,
          @taxJurisdictionId = taxJurisdictionId
     FROM Purchase
    WHERE xactionId = @refXactionId 

    IF (@@rowcount > 0) 
       BEGIN 
          IF (@offerDetailId IS NULL) 
             BEGIN 
                SELECT @cost    = cost, 
                       @costUSD = costUSD, 
                       @tax     = tax, 
                       @taxUSD  = taxUSD 
                  FROM PurchaseSubscriptionDetail 
                 WHERE xactionId = @refXactionId 
                   AND subscriptionOfferDetailId = @subOfferDetailId 
             END 

          -- if reversal not passed through card processor, generate new xactionId and set cardProcessor = null 
          IF (@xactionId = -1)
             BEGIN
                SELECT @cardProcessor = NULL
                EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT

                IF (@return != 0)
                   BEGIN
                      RETURN @return
                   END
             END
           
          SELECT @duration = duration,
                 @durationUnits = durationUnits, 
                 @subscriptionTypeId = subscriptionTypeId
            FROM SubscriptionTransaction
           WHERE xactionId = @refXactionId
             AND subscriptionOfferDetailId = @subOfferDetailId 

          IF (@subscriptionTypeId IS NULL) 
             BEGIN
                SELECT @subscriptionTypeId = 1
             END

          IF (@duration IS NULL)
             BEGIN
                SELECT @duration = 1
             END

          IF (@durationUnits IS NULL)
             BEGIN
                SELECT @durationUnits = 'M' 
             END

          BEGIN TRAN TRAN_adminReverseSubscrPurch

          INSERT INTO SubscriptionTransaction(xactionId,
                                              subscriptionOfferDetailId,
                                              cardId,
                                              userId,
                                              subscriptionTypeId,
                                              duration,
                                              xactionTypeId,
                                              contentId,
                                              description,
                                              dateCreated,
                                              durationUnits)
          VALUES(@xactionId,
                 @subOfferDetailId,
                 @creditCardId,
                 @userId,
                 @subscriptionTypeId,
                 -@duration,
                 @xactionTypeId,
                 @contentId,
                 @adminNote,
                 @dateNow,
                 @durationUnits)

          IF (@@error != 0)
             BEGIN
                ROLLBACK TRAN TRAN_adminReverseSubscrPurch
                RETURN 97
             END

          IF NOT EXISTS(SELECT 1 FROM AdminAccountTransaction
                         WHERE xactionId = @xactionId)
             BEGIN
                INSERT INTO AdminAccountTransaction(xactionId,
                                                    adminUserId,
                                                    userId,
                                                    dateCreated)
                VALUES(@xactionId,
                       @adminUserId,
                       @userId,
                       @dateNow)
             END

          IF (@@error = 0)
             BEGIN
                INSERT INTO Purchase(xactionId,
                                     purchaseTypeId,
                                     billingLocationId,
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
                                     xactionTypeId,
                                     refXactionId,
                                     taxCountryId,
                                     taxJurisdictionId)
                VALUES(@xactionId,
                       @purchaseTypeId,
                       @billingLocationId,
                       @subOfferDetailId,
                       @currencyId,
                       -@cost,
                       -@costUSD,
                       -@tax,
                       -@taxUSD,
                       @userId,
                       @dateNow,
                       @creditCardId,
                       @cardProcessor,
                       @xactionTypeId,
                       @refXactionId,
                       @taxCountryId,
                       @taxJurisdictionId)

                IF (@@error = 0)
                   BEGIN
                      COMMIT TRAN TRAN_adminReverseSubscrPurch
                      RETURN 0
                   END
                ELSE
                   BEGIN
                      ROLLBACK TRAN TRAN_adminReverseSubscrPurch
                      RETURN 98
                   END
             END
          ELSE
             BEGIN
                ROLLBACK TRAN TRAN_adminReverseSubscrPurch
                RETURN 99
             END
       END
END
go

IF OBJECT_ID('dbo.wsp_adminReverseSubscrPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminReverseSubscrPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminReverseSubscrPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_adminReverseSubscrPurchase TO web
go


