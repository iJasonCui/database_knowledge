IF OBJECT_ID('dbo.wsp_adminAdjustSubscrPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminAdjustSubscrPurchase
    IF OBJECT_ID('dbo.wsp_adminAdjustSubscrPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminAdjustSubscrPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminAdjustSubscrPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 16, 2006
**   Description:  adjust  subscription purchase for user
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminAdjustSubscrPurchase
   @userId        NUMERIC(12, 0),
   @xactionId     NUMERIC(12, 0),
   @refXactionId  NUMERIC(12, 0),
   @contentId     SMALLINT,
   @xactionTypeId TINYINT,
   @cardProcessor CHAR(1),
   @adminUserId   INT,
   @adminNote     VARCHAR(255)
AS

BEGIN
   DECLARE @return                    INT,
           @subscriptionTypeId        TINYINT,
           @dateNow                   DATETIME,
           @cost                      NUMERIC(10,2),
           @costUSD                   NUMERIC(5,2),
           @tax                       NUMERIC(10,2),
           @taxUSD                    NUMERIC(5,2),
           @currencyId                TINYINT,
           @subscriptionOfferDetailId SMALLINT,
           @purchaseTypeId            TINYINT,
           @billingLocationId         SMALLINT,
           @creditCardId              INT,
           @durationUnits             CHAR(1),
           @purchaseXactionId         NUMERIC(12, 0)

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   
   IF (@return != 0)
      BEGIN
         RETURN @return
      END

   SELECT @creditCardId              = creditCardId,
          @currencyId                = currencyId,
          @subscriptionOfferDetailId = subscriptionOfferDetailId,
          @billingLocationId         = billingLocationId,
          @purchaseTypeId            = purchaseTypeId
     FROM Purchase
    WHERE xactionId = @refXactionId

   IF (@@rowcount > 0)
      BEGIN
         IF (@subscriptionOfferDetailId IS NULL) 
            BEGIN
               DECLARE CUR_subDetail CURSOR FOR
                SELECT subscriptionOfferDetailId
                  FROM PurchaseSubscriptionDetail
                 WHERE xactionId = @refXactionId
               FOR READ ONLY

               OPEN CUR_subDetail
               FETCH CUR_subDetail INTO @subscriptionOfferDetailId
 
               WHILE (@@sqlstatus != 2)
               BEGIN
                  IF (@@sqlstatus = 1)
                     BEGIN
                        CLOSE CUR_subDetail
                        DEALLOCATE CURSOR CUR_subDetail
                        RETURN 98
                     END

                  BEGIN TRAN TRAN_adminAdjustSubscrPurchase

                  EXEC @return = dbo.wsp_XactionId @purchaseXactionId OUTPUT

                  SELECT @subscriptionTypeId = subscriptionTypeId,
                         @durationUnits = durationUnits
                    FROM SubscriptionTransaction
                   WHERE xactionId = @refXactionId
                     AND subscriptionOfferDetailId = @subscriptionOfferDetailId

                  IF (@subscriptionTypeId IS NULL)
                     BEGIN
                        SELECT @subscriptionTypeId = 1
                     END

                  IF (@durationUnits IS NULL)
                     BEGIN
                        SELECT @durationUnits = 'M'
                     END

                  INSERT INTO SubscriptionTransaction(xactionId,
                                                      userId,
                                                      cardId,
                                                      subscriptionTypeId,
                                                      xactionTypeId,
                                                      contentId,
                                                      duration,
                                                      userTrans,
                                                      durationUnits,
                                                      description,
                                                      dateCreated,
                                                      subscriptionOfferDetailId)
                  VALUES(@purchaseXactionId,
                         @userId,
                         @creditCardId,
                         @subscriptionTypeId,
                         @xactionTypeId,
                         @contentId,
                         0,
                         0,
                         @durationUnits,
                         @adminNote,
                         @dateNow,
                         @subscriptionOfferDetailId)
                    
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
                                       refXactionId)
                  VALUES(@purchaseXactionId,
                         @purchaseTypeId,
                         @billingLocationId,
                         @subscriptionOfferDetailId,
                         @currencyId,
                         0,
                         0,
                         0,
                         0,
                         @userId,
                         @dateNow,
                         @creditCardId,
                         @cardProcessor,
                         @xactionTypeId,
                         @refXactionId)
                  
                  IF (@@error = 0)
                     BEGIN
                        INSERT INTO AdminAccountTransaction(xactionId,
                                                            adminUserId,
                                                            userId,
                                                            dateCreated)
                        VALUES(@purchaseXactionId,
                               @adminUserId,
                               @userId,
                               @dateNow)

                        IF (@@error = 0)
                           BEGIN
                              COMMIT TRAN TRAN_adminAdjustSubscrPurchase
                           END
                        ELSE
                           BEGIN
                              ROLLBACK TRAN TRAN_adminAdjustSubscrPurchase
                           END

                     END
                  ELSE
                     BEGIN
                        ROLLBACK TRAN TRAN_adminAdjustSubscrPurchase
                     END

                  FETCH CUR_subDetail INTO @subscriptionOfferDetailId
               END
 
               CLOSE CUR_subDetail
               DEALLOCATE CURSOR CUR_subDetail
               RETURN 0
            END
         ELSE  
            BEGIN
               BEGIN TRAN TRAN_adminAdjustSubscrPurchase

               SELECT @subscriptionTypeId = subscriptionTypeId,
                      @durationUnits = durationUnits
                 FROM SubscriptionTransaction
                WHERE xactionId = @refXactionId
                  AND subscriptionOfferDetailId = @subscriptionOfferDetailId

               IF (@subscriptionTypeId IS NULL)
                  BEGIN
                     SELECT @subscriptionTypeId = 1
                  END

               IF (@durationUnits IS NULL)
                  BEGIN
                     SELECT @durationUnits = 'M'
                  END

               INSERT INTO SubscriptionTransaction(xactionId,
                                                   userId,
                                                   cardId,
                                                   subscriptionTypeId,
                                                   xactionTypeId,
                                                   contentId,
                                                   duration,
                                                   userTrans,
                                                   durationUnits,
                                                   description,
                                                   dateCreated,
                                                   subscriptionOfferDetailId)
               VALUES(@xactionId,
                      @userId,
                      @creditCardId,
                      @subscriptionTypeId,
                      @xactionTypeId,
                      @contentId,
                      0,
                      0,
                      @durationUnits,
                      @adminNote,
                      @dateNow,
                      @subscriptionOfferDetailId)

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
                                    refXactionId)
               VALUES(@xactionId,
                      @purchaseTypeId,
                      @billingLocationId,
                      @subscriptionOfferDetailId,
                      @currencyId,
                      0,
                      0,
                      0,
                      0,
                      @userId,
                      @dateNow,
                      @creditCardId,
                      @cardProcessor,
                      @xactionTypeId,
                      @refXactionId)
 
               IF (@@error = 0)
                  BEGIN
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

                          IF (@@error = 0)
                             BEGIN
                                COMMIT TRAN TRAN_adminAdjustSubscrPurchase
                                RETURN 0
                             END
                          ELSE
                             BEGIN
                                ROLLBACK TRAN TRAN_adminAdjustSubscrPurchase
                                RETURN 98
                             END
                        END
                     ELSE
                        BEGIN
                           COMMIT TRAN TRAN_adminAdjustSubscrPurchase
                           RETURN 0
                        END
                  END
	       ELSE
                  BEGIN
                      ROLLBACK TRAN TRAN_adminAdjustSubscrPurchase
                      RETURN 99
                  END
            END
      END
END
go

IF OBJECT_ID('dbo.wsp_adminAdjustSubscrPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminAdjustSubscrPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminAdjustSubscrPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_adminAdjustSubscrPurchase TO web
go


