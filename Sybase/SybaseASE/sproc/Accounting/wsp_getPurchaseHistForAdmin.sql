IF OBJECT_ID('dbo.wsp_getPurchaseHistForAdmin') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPurchaseHistForAdmin
    IF OBJECT_ID('dbo.wsp_getPurchaseHistForAdmin') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPurchaseHistForAdmin >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPurchaseHistForAdmin >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Oct 1, 2003
**   Description:  retrieves purchase transactions for the specified user
**
** REVISION(S):
**   Author:       Mike Stairs
**   Date:         November 26, 2004
**   Description:  retrieve subcription related info too
**
**   Author:       Andy Tran
**   Date:         December 2005
**   Description:  use union to retrieve both regular and subscription purchases
**
**   Author:       Andy Tran
**   Date:         August 2006
**   Description:  added userIP (the IP number at time of purchase)
**
**   Author:       Yan Liu 
**   Date:         April 2008
**   Description:  rewrite this proc for upsell 
**
**   Author:       Eugene Huang 
**   Date:         February 2009
**   Description:  added fetching for X for Y Subscription purchases,
*                  and append discountCode to description
**
**   Author:       Andy Tran 
**   Date:         July 2009
**   Description:  added SpeedDating purchases
**
**   Author:       TK Chan  
**   Date:         May 2010
**   Description:  added support to show Tax codes
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getPurchaseHistForAdmin
   @userId    NUMERIC(12, 0),
   @startDate DATETIME

AS
BEGIN
   CREATE TABLE #tmp_purchaseHistory
   (
      xactionId          NUMERIC(12, 0) NOT NULL,
      xactionTypeId      TINYINT        NOT NULL,
      dateCreated        DATETIME       NOT NULL,
      cost               NUMERIC(10, 2) NULL,
      costUSD            NUMERIC(5, 2)  NULL,
      tax                NUMERIC(10, 2) NULL,
      taxUSD             NUMERIC(5, 2)  NULL,
      purchaseTypeId     TINYINT        NULL, 
      paymentNumber      VARCHAR(40)    NULL,
      creditCardId       INT            NULL,
      offerDetailId      SMALLINT       NULL,
      currencyId         TINYINT        NULL,
      cardProcessor      CHAR(1)        NULL, 
      billingLocationId  SMALLINT       NOT NULL,
      refXactionId       NUMERIC(12, 0) NULL,
      contentId          SMALLINT       NULL,
      description        VARCHAR(255)   NULL,
      adminUserId        INT            NULL,
      purchaseType       VARCHAR(2)     NOT NULL,
      userIP             NUMERIC(12, 0) NULL,
      discountFlag       CHAR(1)        NULL,
      taxCountryId       smallint       NULL,
      taxJurisdictionId  int            NULL,
      taxCodeName        VARCHAR(203)   NULL
   )

   DECLARE @xactionId         NUMERIC(12, 0) 
   DECLARE @xactionTypeId     TINYINT        
   DECLARE @dateCreated       DATETIME       
   DECLARE @cost              NUMERIC(10, 2) 
   DECLARE @costUSD           NUMERIC(5, 2)  
   DECLARE @tax               NUMERIC(10, 2) 
   DECLARE @taxUSD            NUMERIC(5, 2)  
   DECLARE @purchaseTypeId    TINYINT        
   DECLARE @paymentNumber     VARCHAR(40)    
   DECLARE @creditCardId      INT            
   DECLARE @creditDetailId    SMALLINT       
   DECLARE @subDetailId       SMALLINT       
   DECLARE @offerDetailId     SMALLINT       
   DECLARE @currencyId        TINYINT        
   DECLARE @cardProcessor     CHAR(1)        
   DECLARE @billingLocationId SMALLINT       
   DECLARE @refXactionId      NUMERIC(12, 0) 
   DECLARE @contentId         SMALLINT       
   DECLARE @description       VARCHAR(255)   
   DECLARE @adminUserId       INT            
   DECLARE @purchaseType      VARCHAR(2)        
   DECLARE @userIP            NUMERIC(12, 0) 
   DECLARE @subRecordCount    TINYINT
   DECLARE @discountFlag      CHAR(1)
   DECLARE @taxCountryId      SMALLINT
   DECLARE @taxJurisdictionId INT
   DECLARE @taxCodeName       VARCHAR(203)
   
   DECLARE CUR_purchaseHist CURSOR FOR
    SELECT xactionId,
           xactionTypeId,
           dateCreated,
           cost,
           costUSD,
           tax,
           taxUSD,
           purchaseTypeId,
           paymentNumber,
           creditCardId,
           purchaseOfferDetailId, 
           subscriptionOfferDetailId,
           currencyId,
           cardProcessor,
           billingLocationId,
           refXactionId,
           userIP,
           discountFlag,
           taxCountryId,
           taxJurisdictionId
      FROM Purchase
     WHERE userId = @userId 
       AND dateCreated >= @startDate
     ORDER BY xactionId ASC
   FOR READ ONLY
 
   OPEN CUR_purchaseHist
   FETCH CUR_purchaseHist INTO @xactionId,
                               @xactionTypeId,
                               @dateCreated,
                               @cost,
                               @costUSD,           
                               @tax,               
                               @taxUSD,            
                               @purchaseTypeId,    
                               @paymentNumber,     
                               @creditCardId,      
                               @creditDetailId,    
                               @subDetailId,      
                               @currencyId,        
                               @cardProcessor,     
                               @billingLocationId, 
                               @refXactionId,      
                               @userIP,
                               @discountFlag,
                               @taxCountryId,
                               @taxJurisdictionId

   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_purchaseHist 
            DEALLOCATE CURSOR CUR_purchaseHist
            RETURN 99
         END
         
      SELECT @taxCodeName = 
         CASE WHEN @taxCountryId IS NULL AND @taxJurisdictionId IS NULL THEN 'N/A'
              WHEN @taxCountryId = -1 AND @taxJurisdictionId = -1 THEN 'UNKNOWN'
              WHEN @taxCountryId = 0  AND @taxJurisdictionId = 0 THEN 'NO TAX'
              WHEN @taxCountryId > 0 AND @taxJurisdictionId = -1 THEN (SELECT countryName FROM CountryTaxRate WHERE countryId = @taxCountryId AND dateExpired IS NULL)
              ELSE (SELECT countryName FROM CountryTaxRate WHERE countryId = @taxCountryId AND dateExpired IS NULL) + ' - ' +
                   (SELECT jurisdictionName FROM JurisdictionTaxRate WHERE jurisdictionId = @taxJurisdictionId AND dateExpired IS NULL)
              END 

      IF (@creditDetailId > 0) 
         BEGIN
            SELECT @offerDetailId = @creditDetailId

            IF (@purchaseTypeId = 18)
               BEGIN
                  SELECT @purchaseType = 'SD'
               END
            ELSE
               BEGIN
                  SELECT @purchaseType = 'P'
               END
         END
      ELSE 
         BEGIN
            SELECT @purchaseType = 'S'

            IF (@subDetailId > 0)
               BEGIN
                  SELECT @offerDetailId = @subDetailId
               END
         END 

      IF (@purchaseType = 'SD')
         BEGIN
            IF EXISTS (SELECT 1 FROM SDTransaction WHERE xactionId = @xactionId)
               BEGIN
                  SELECT @contentId = contentId
                        ,@description = NULL
                    FROM SDTransaction
                   WHERE xactionId = @xactionId
               END 
            ELSE
               BEGIN
                  SELECT @contentId = NULL
                        ,@description = NULL
               END 
         END
      ELSE
         BEGIN
            IF (@purchaseType = 'P')
               BEGIN
                  IF EXISTS(SELECT 1 FROM AccountTransaction WHERE xactionId = @xactionId)
                     BEGIN
                        SELECT @contentId = contentId
                              ,@description = description
                          FROM AccountTransaction
                         WHERE xactionId = @xactionId
                     END
                  ELSE
                     BEGIN
                        SELECT @contentId = NULL
                              ,@description = NULL 
                     END
               END
            ELSE
               BEGIN
                  IF (@subDetailId > 0)
                     BEGIN
                        IF EXISTS(SELECT 1 FROM SubscriptionTransaction WHERE xactionId = @xactionId AND subscriptionOfferDetailId = @subDetailId)
                           BEGIN
                              SELECT @contentId = contentId
                                    ,@description = description
                                FROM SubscriptionTransaction
                               WHERE xactionId = @xactionId
                                 AND subscriptionOfferDetailId = @subDetailId
                           END 
                        ELSE
                           BEGIN
                              SELECT @contentId = NULL
                                    ,@description = NULL 
                           END 
                     END
                  ELSE
                     BEGIN
                        IF (@subDetailId is null and @discountFlag = 'Y')
                           BEGIN
                              IF EXISTS(SELECT 1 FROM SubscriptionTransaction WHERE xactionId = @xactionId)
                                 BEGIN
                                    SELECT @contentId = contentId
                                          ,@description = description
                                      FROM SubscriptionTransaction
                                     WHERE xactionId = @xactionId
                                 END
                              ELSE
                                 BEGIN
                                    SELECT @contentId = NULL
                                          ,@description = NULL 
                                 END 
                           END
                     END
               END
         END 

      IF EXISTS(SELECT 1 FROM AdminAccountTransaction WHERE xactionId = @xactionId) 
         BEGIN
            SELECT @adminUserId = adminUserId
              FROM AdminAccountTransaction 
             WHERE xactionId = @xactionId
         END
      ELSE
         BEGIN
            SELECT @adminUserId = NULL 
         END

      IF (@creditDetailId IS NULL AND @subDetailId IS NULL) -- AND @discountFlag != 'Y')
         BEGIN
            ----------------- subscription detail  --------------
            SELECT @subRecordCount = 0
            DECLARE CUR_purchaseSubDetail CURSOR FOR
             SELECT subscriptionOfferDetailId,
                    cost,
                    costUSD,
                    tax,
                    taxUSD
               FROM PurchaseSubscriptionDetail 
              WHERE xactionId = @xactionId
            FOR READ ONLY

            OPEN CUR_purchaseSubDetail
            FETCH CUR_purchaseSubDetail INTO @offerDetailId, 
                                             @cost,
                                             @costUSD,
                                             @tax,
                                             @taxUSD

            ----------------- subscription detail  while loop begin --------------
            WHILE (@@sqlstatus != 2) 
               BEGIN
                  IF (@@sqlstatus = 1)
                     BEGIN
                        CLOSE CUR_purchaseSubDetail 
                        DEALLOCATE CURSOR CUR_purchaseSubDetail 
                        RETURN 98
                     END

                  IF EXISTS(SELECT 1 FROM SubscriptionTransaction WHERE xactionId = @xactionId AND subscriptionOfferDetailId = @offerDetailId)
                     BEGIN
                        SELECT @contentId = contentId,
                               @description = description
                          FROM SubscriptionTransaction
                         WHERE xactionId = @xactionId
                           AND subscriptionOfferDetailId = @offerDetailId
                     END
                  ELSE
                     BEGIN
                        SELECT @contentId = NULL,
                               @description = NULL 
                     END
 
                  BEGIN TRAN TRAN_insPurchaseHist
                  SELECT @subRecordCount = @subRecordCount + 1
                  INSERT INTO #tmp_purchaseHistory(xactionId,
                                                   xactionTypeId,
                                                   dateCreated,
                                                   cost,
                                                   costUSD,
                                                   tax,
                                                   taxUSD,
                                                   purchaseTypeId,
                                                   paymentNumber,
                                                   creditCardId,
                                                   offerDetailId,
                                                   currencyId,
                                                   cardProcessor,
                                                   billingLocationId,
                                                   refXactionId,
                                                   contentId,
                                                   description,
                                                   adminUserId,
                                                   purchaseType,
                                                   userIP,
                                                   discountFlag,
                                                   taxCountryId,
                                                   taxJurisdictionId,
                                                   taxCodeName
                                                   )
                  VALUES(@xactionId,
                         @xactionTypeId,
                         @dateCreated,
                         @cost,
                         @costUSD,
                         @tax,
                         @taxUSD,
                         @purchaseTypeId,
                         @paymentNumber,
                         @creditCardId,
                         @offerDetailId,
                         @currencyId,
                         @cardProcessor,
                         @billingLocationId,
                         @refXactionId,
                         @contentId,
                         @description,
                         @adminUserId,
                         @purchaseType,
                         @userIP,
                         @discountFlag,
                         @taxCountryId,
                         @taxJurisdictionId,
                         @taxCodeName                         
                         )

                  IF (@@error = 0)
                     BEGIN
                        COMMIT TRAN TRAN_insPurchaseHist
                     END
                  ELSE
                     BEGIN
                        ROLLBACK TRAN TRAN_insPurchaseHist
                     END

                  FETCH CUR_purchaseSubDetail INTO @offerDetailId,
                                                   @cost,
                                                   @costUSD,
                                                   @tax,
                                                   @taxUSD
               END
               ----------------- subscription detail  while loop end --------------

            -- changed on Sep 29,2009, credit users would use upsell features  
            CLOSE CUR_purchaseSubDetail 
            DEALLOCATE CURSOR CUR_purchaseSubDetail 
            ----------------- fetch subscription detail line item end --------------


            ----------------- fetch credit detail line items --------------
            -- SELECT @subRecordCount = 0
            DECLARE CUR_purchaseCreditDetail CURSOR FOR
             SELECT purchaseOfferDetailId,
                    cost,
                    costUSD,
                    tax,
                    taxUSD
               FROM PurchaseCreditDetail 
              WHERE xactionId = @xactionId
            FOR READ ONLY

            OPEN CUR_purchaseCreditDetail
            FETCH CUR_purchaseCreditDetail INTO @offerDetailId, 
                                             @cost,
                                             @costUSD,
                                             @tax,
                                             @taxUSD

            ----------------- credit detail  while loop begin --------------
            WHILE (@@sqlstatus != 2) 
               BEGIN
                  IF (@@sqlstatus = 1)
                     BEGIN
                        CLOSE CUR_purchaseCreditDetail 
                        DEALLOCATE CURSOR CUR_purchaseCreditDetail 
                        RETURN 98
                     END

                  IF EXISTS(SELECT 1 FROM AccountTransaction WHERE xactionId = @xactionId) --AND purchaseOfferDetailId = @offerDetailId)
                     BEGIN
                        SELECT @contentId = contentId,
                               @description = description
                          FROM AccountTransaction
                         WHERE xactionId = @xactionId
                           --AND purchaseOfferDetailId = @offerDetailId
                     END
                  ELSE
                     BEGIN
                        SELECT @contentId = NULL,
                               @description = NULL 
                     END
 
                  BEGIN TRAN TRAN_insPurchaseHist
                  SELECT @subRecordCount = @subRecordCount + 1
                  INSERT INTO #tmp_purchaseHistory(xactionId,
                                                   xactionTypeId,
                                                   dateCreated,
                                                   cost,
                                                   costUSD,
                                                   tax,
                                                   taxUSD,
                                                   purchaseTypeId,
                                                   paymentNumber,
                                                   creditCardId,
                                                   offerDetailId,
                                                   currencyId,
                                                   cardProcessor,
                                                   billingLocationId,
                                                   refXactionId,
                                                   contentId,
                                                   description,
                                                   adminUserId,
                                                   purchaseType,
                                                   userIP,
                                                   discountFlag,
                                                   taxCountryId,
                                                   taxJurisdictionId,
                                                   taxCodeName                         
                                                   )
                  VALUES(@xactionId,
                         @xactionTypeId,
                         @dateCreated,
                         @cost,
                         @costUSD,
                         @tax,
                         @taxUSD,
                         @purchaseTypeId,
                         @paymentNumber,
                         @creditCardId,
                         @offerDetailId,
                         @currencyId,
                         @cardProcessor,
                         @billingLocationId,
                         @refXactionId,
                         @contentId,
                         @description,
                         @adminUserId,
                         'P',
                         @userIP,
                         @discountFlag,
                         @taxCountryId,
                         @taxJurisdictionId,
                         @taxCodeName                         
                         )

                  IF (@@error = 0)
                     BEGIN
                        COMMIT TRAN TRAN_insPurchaseHist
                     END
                  ELSE
                     BEGIN
                        ROLLBACK TRAN TRAN_insPurchaseHist
                     END

                  FETCH CUR_purchaseCreditDetail INTO @offerDetailId,
                                                   @cost,
                                                   @costUSD,
                                                   @tax,
                                                   @taxUSD
               END
               ----------------- credit detail  while loop end --------------
 
            CLOSE CUR_purchaseCreditDetail 
            DEALLOCATE CURSOR CUR_purchaseCreditDetail 
            --------------- fetch credit line item end  --------------



            --------------- means no line items? --------------
            IF @subRecordCount = 0 
               BEGIN
                  SELECT @cost = isNull(amount/100,0),
                         @description = 'code=' + responseCode + ' cavvResponse=' + cavvResponseCode
                    FROM PaymentechResponse where xactionId = @xactionId

                  BEGIN TRAN TRAN_insPurchaseHist
                     INSERT INTO #tmp_purchaseHistory(xactionId,
                                                      xactionTypeId,
                                                      dateCreated,
                                                      cost,
                                                      costUSD,
                                                      tax,
                                                      taxUSD,
                                                      purchaseTypeId,
                                                      paymentNumber,
                                                      creditCardId,
                                                      offerDetailId,
                                                      currencyId,
                                                      cardProcessor,
                                                      billingLocationId,
                                                      refXactionId,
                                                      contentId,
                                                      description,
                                                      adminUserId,
                                                      purchaseType,
                                                      userIP,
                                                      discountFlag,
                                                      taxCountryId,
                                                      taxJurisdictionId,
                                                      taxCodeName                         
                                                      )
                     VALUES(@xactionId,
                            @xactionTypeId,
                            @dateCreated,
                            @cost,
                            @costUSD,
                            @tax,
                            @taxUSD,
                            @purchaseTypeId,
                            @paymentNumber,
                            @creditCardId,
                            @offerDetailId,
                            @currencyId,
                            @cardProcessor,
                            @billingLocationId,
                            @refXactionId,
                            @contentId,
                            @description,
                            @adminUserId,
                            @purchaseType,
                            @userIP,
                            @discountFlag,
                            @taxCountryId,
                            @taxJurisdictionId,
                            @taxCodeName                         
                            )

                     IF (@@error = 0)
                        BEGIN
                           COMMIT TRAN TRAN_insPurchaseHist
                        END
                     ELSE
                        BEGIN
                           ROLLBACK TRAN TRAN_insPurchaseHist
                        END
               END
         END
      ELSE
         BEGIN
            BEGIN TRAN TRAN_insPurchaseHist
               INSERT INTO #tmp_purchaseHistory(xactionId,
                                                xactionTypeId,      
                                                dateCreated,        
                                                cost,               
                                                costUSD,            
                                                tax,                
                                                taxUSD,             
                                                purchaseTypeId,     
                                                paymentNumber,      
                                                creditCardId,       
                                                offerDetailId,      
                                                currencyId,         
                                                cardProcessor,      
                                                billingLocationId,  
                                                refXactionId,       
                                                contentId,          
                                                description,        
                                                adminUserId,        
                                                purchaseType,       
                                                userIP,
                                                discountFlag,
                                                taxCountryId,
                                                taxJurisdictionId,
                                                taxCodeName                         
                                                )           
               VALUES(@xactionId,
                      @xactionTypeId,
                      @dateCreated,
                      @cost,
                      @costUSD,
                      @tax,
                      @taxUSD,
                      @purchaseTypeId,
                      @paymentNumber,
                      @creditCardId,
                      @offerDetailId,
                      @currencyId,
                      @cardProcessor,
                      @billingLocationId,
                      @refXactionId,
                      @contentId,
                      @description,
                      @adminUserId,
                      @purchaseType,
                      @userIP,
                      @discountFlag,
                      @taxCountryId,
                      @taxJurisdictionId,
                      @taxCodeName                         
                      )

               IF (@@error = 0)
                  BEGIN
                     COMMIT TRAN TRAN_insPurchaseHist 
                  END
               ELSE
                  BEGIN
                     ROLLBACK TRAN TRAN_insPurchaseHist 
                  END
         END

         FETCH CUR_purchaseHist INTO @xactionId,
                                     @xactionTypeId,
                                     @dateCreated,
                                     @cost,
                                     @costUSD,
                                     @tax,
                                     @taxUSD,
                                     @purchaseTypeId,
                                     @paymentNumber,
                                     @creditCardId,
                                     @creditDetailId,
                                     @subDetailId,
                                     @currencyId,
                                     @cardProcessor,
                                     @billingLocationId,
                                     @refXactionId,
                                     @userIP,
                                     @discountFlag,
                                     @taxCountryId,
                                     @taxJurisdictionId
   END 

   SELECT t.xactionId,
          t.xactionTypeId,
          t.dateCreated,
          t.cost,
          t.costUSD,
          t.tax,
          t.taxUSD,
          t.purchaseTypeId,
          t.paymentNumber,
          t.creditCardId,
          t.offerDetailId,
          t.currencyId,
          t.cardProcessor,
          t.billingLocationId,
          t.refXactionId,
          t.contentId,
          (CASE t.discountFlag WHEN 'Y'
              THEN CASE p.discountCode WHEN NULL
                 THEN t.description
                 ELSE coalesce(t.description,'') + ' discount code: ' + p.discountCode END
              ELSE t.description END),
          t.adminUserId,
          t.purchaseType,
          t.userIP      ,
          t.taxCodeName 
     FROM #tmp_purchaseHistory t, PurchaseDiscount p
    WHERE t.xactionId *= p.xactionId
      AND t.offerDetailId *= p.offerDetailId

   RETURN @@error
END
go
EXEC sp_procxmode 'dbo.wsp_getPurchaseHistForAdmin','unchained'
go
IF OBJECT_ID('dbo.wsp_getPurchaseHistForAdmin') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPurchaseHistForAdmin >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPurchaseHistForAdmin >>>'
go
GRANT EXECUTE ON dbo.wsp_getPurchaseHistForAdmin TO web
go
