
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  December 8, 2004
**   Description:  retrieves SubscriptionTransactions for a given userId (for a specified period of time.)
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Jan 12, 2006
**   Description: added durationUnits
**
** REVISION(S):
**   Author: Andy Tran
**   Date: Feb 22, 2006
**   Description: added tax
**
** REVISION(S):
**   Author: Yan Liu
**   Date: April 21, 2008
**   Description: rewrite this proc due to upsell architecture.  
**
******************************************************************************/
IF OBJECT_ID('dbo.wsp_getSubscriptionTransaction') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getSubscriptionTransaction
   IF OBJECT_ID('dbo.wsp_getSubscriptionTransaction') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubscriptionTransaction >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubscriptionTransaction >>>'
END
go

CREATE PROCEDURE dbo.wsp_getSubscriptionTransaction
   @userId      NUMERIC(12,0),
   @startDate   DATETIME
AS

BEGIN
   CREATE TABLE #tmp_subscriptionTrans
   (
      userId             NUMERIC(12, 0) NOT NULL,
      xactionId          NUMERIC(12, 0) NOT NULL,
      xactionTypeId      TINYINT        NOT NULL,
      contentId          SMALLINT       NOT NULL,
      subscriptionTypeId SMALLINT       NOT NULL,
      duration           SMALLINT       NOT NULL,
      durationUnits      CHAR(1)        NULL,
      description        VARCHAR(255)   NULL,
      dateCreated        DATETIME       NOT NULL,
      cost               NUMERIC(10, 2) NULL,
      tax                NUMERIC(10, 2) NULL,
      currencyId         TINYINT        NULL
   )

   DECLARE @xactionId                 NUMERIC(12, 0)
   DECLARE @xactionTypeId             TINYINT
   DECLARE @contentId                 SMALLINT
   DECLARE @subscriptionTypeId        SMALLINT
   DECLARE @duration                  SMALLINT
   DECLARE @durationUnits             CHAR(1) 
   DECLARE @description               VARCHAR(255) 
   DECLARE @dateCreated               DATETIME 
   DECLARE @subscriptionOfferDetailId INT

   DECLARE @cost       NUMERIC(10, 2)
   DECLARE @tax        NUMERIC(10, 2)
   DECLARE @currencyId TINYINT 

   DECLARE @sOfferDetailId INT 

   DECLARE CUR_subscriptionTrans CURSOR FOR
    SELECT xactionId,
           xactionTypeId,
           contentId,
           subscriptionTypeId, 
           duration, 
           durationUnits,
           description, 
           dateCreated,
           ISNULL(subscriptionOfferDetailId, 0)
      FROM SubscriptionTransaction
     WHERE userId = @userId
       AND dateCreated > @startDate
     ORDER BY dateCreated ASC 
   FOR READ ONLY
   
   OPEN CUR_subscriptionTrans 
   FETCH CUR_subscriptionTrans INTO @xactionId, 
                                    @xactionTypeId,
                                    @contentId,
                                    @subscriptionTypeId,
                                    @duration,
                                    @durationUnits,
                                    @description,
                                    @dateCreated,
                                    @subscriptionOfferDetailId

   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_subscriptionTrans
            DEALLOCATE CURSOR CUR_subscriptionTrans 
            RETURN 99
         END

      IF EXISTS(SELECT 1 FROM Purchase WHERE xactionId = @xactionId) 
         BEGIN
            SELECT @currencyId = currencyId, 
                   @cost = cost,   
                   @tax = tax,
                   @sOfferDetailId = ISNULL(subscriptionOfferDetailId, 0)
              FROM Purchase 
             WHERE xactionId = @xactionId      

            IF (@subscriptionOfferDetailId > 0) 
               BEGIN
                  IF (@sOfferDetailId > 0) 
                     BEGIN
                        BEGIN TRAN TRAN_insSubTrans

                        INSERT INTO #tmp_subscriptionTrans(userId,
                                                           xactionId,
                                                           xactionTypeId,
                                                           contentId,
                                                           subscriptionTypeId,
                                                           duration,
                                                           durationUnits,
                                                           description,
                                                           dateCreated,
                                                           cost,
                                                           tax,
                                                           currencyId)
                        VALUES(@userId,
                               @xactionId,
                               @xactionTypeId,
                               @contentId,
                               @subscriptionTypeId,
                               @duration,
                               @durationUnits,
                               @description,
                               @dateCreated,
                               @cost,
                               @tax,
                               @currencyId)

                        IF (@@error = 0)
                           BEGIN
                              COMMIT TRAN TRAN_insSubTrans
                           END
                        ELSE
                           BEGIN
                              ROLLBACK TRAN TRAN_insSubTrans 
                           END
                     END
                  ELSE
                     BEGIN
                        IF EXISTS(SELECT 1 FROM PurchaseSubscriptionDetail
                                   WHERE xactionId = @xactionId
                                     AND subscriptionOfferDetailId = @subscriptionOfferDetailId)
                           BEGIN
                              SELECT @cost = cost,
                                     @tax = tax  
                                FROM PurchaseSubscriptionDetail
                               WHERE xactionId = @xactionId
                                 AND subscriptionOfferDetailId = @subscriptionOfferDetailId
                              
                              INSERT INTO #tmp_subscriptionTrans(userId,
                                                                 xactionId,
                                                                 xactionTypeId,
                                                                 contentId,
                                                                 subscriptionTypeId,
                                                                 duration,
                                                                 durationUnits,
                                                                 description,
                                                                 dateCreated,
                                                                 cost,
                                                                 tax,
                                                                 currencyId)
                              VALUES(@userId,
                                     @xactionId,
                                     @xactionTypeId,
                                     @contentId,
                                     @subscriptionTypeId,
                                     @duration,
                                     @durationUnits,
                                     @description,
                                     @dateCreated,
                                     @cost,
                                     @tax,
                                     @currencyId)

                              IF (@@error = 0)
                                 BEGIN
                                    COMMIT TRAN TRAN_insSubTrans
                                 END
                              ELSE
                                 BEGIN
                                    ROLLBACK TRAN TRAN_insSubTrans
                                 END
                           END 
                        ELSE
                           BEGIN
                              BEGIN TRAN TRAN_insSubTrans

                              INSERT INTO #tmp_subscriptionTrans(userId,
                                                                 xactionId,
                                                                 xactionTypeId,
                                                                 contentId,
                                                                 subscriptionTypeId,
                                                                 duration,
                                                                 durationUnits,
                                                                 description,
                                                                 dateCreated,
                                                                 cost,
                                                                 tax,
                                                                 currencyId)
                              VALUES(@userId,
                                     @xactionId,
                                     @xactionTypeId,
                                     @contentId,
                                     @subscriptionTypeId,
                                     @duration,
                                     @durationUnits,
                                     @description,
                                     @dateCreated,
                                     NULL,
                                     NULL,
                                     @currencyId)

                              IF (@@error = 0)
                                 BEGIN
                                    COMMIT TRAN TRAN_insSubTrans
                                 END
                              ELSE
                                 BEGIN
                                    ROLLBACK TRAN TRAN_insSubTrans
                                 END

                           END 
                     END
               END
            ELSE
               BEGIN
                  BEGIN TRAN TRAN_insSubTrans

                  INSERT INTO #tmp_subscriptionTrans(userId,
                                                     xactionId,          
                                                     xactionTypeId,      
                                                     contentId,         
                                                     subscriptionTypeId, 
                                                     duration,
                                                     durationUnits,      
                                                     description,        
                                                     dateCreated,        
                                                     cost,               
                                                     tax,                
                                                     currencyId)  
                  VALUES(@userId, 
                         @xactionId,
                         @xactionTypeId,
                         @contentId,
                         @subscriptionTypeId,
                         @duration,
                         @durationUnits,
                         @description,
                         @dateCreated,
                         @cost,
                         @tax,
                         @currencyId)

                  IF (@@error = 0)
                     BEGIN
                        COMMIT TRAN TRAN_insSubTrans 
                     END
                  ELSE
                     BEGIN
                        ROLLBACK TRAN TRAN_insSubTrans 
                     END
               END
         END
      ELSE
         BEGIN
            BEGIN TRAN TRAN_insSubTrans

            INSERT INTO #tmp_subscriptionTrans(userId,
                                               xactionId,
                                               xactionTypeId,
                                               contentId,
                                               subscriptionTypeId,
                                               duration,
                                               durationUnits,
                                               description,
                                               dateCreated,
                                               cost,
                                               tax,
                                               currencyId)
            VALUES(@userId,
                   @xactionId,
                   @xactionTypeId,
                   @contentId,
                   @subscriptionTypeId,
                   @duration,
                   @durationUnits,
                   @description,
                   @dateCreated,
                   NULL,
                   NULL,
                   NULL)

            IF (@@error = 0)
               BEGIN
                  COMMIT TRAN TRAN_insSubTrans
               END
            ELSE
               BEGIN
                  ROLLBACK TRAN TRAN_insSubTrans
               END
         END

      FETCH CUR_subscriptionTrans INTO @xactionId,
                                       @xactionTypeId,
                                       @contentId,
                                       @subscriptionTypeId,
                                       @duration,
                                       @durationUnits,
                                       @description,
                                       @dateCreated,
                                       @subscriptionOfferDetailId
   END

   CLOSE CUR_subscriptionTrans
   DEALLOCATE CURSOR CUR_subscriptionTrans

   SELECT userId, 
          xactionId,
          xactionTypeId,
          contentId,    
          subscriptionTypeId,
          duration,
          description,  
          dateCreated,
          -1,   -- cardId
          NULL, -- card nickname
          cost,
          currencyId,
          durationUnits,
          tax
     FROM #tmp_subscriptionTrans

   RETURN @@error 
END
go

GRANT EXECUTE ON dbo.wsp_getSubscriptionTransaction TO web
go

IF OBJECT_ID('dbo.wsp_getSubscriptionTransaction') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubscriptionTransaction >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubscriptionTransaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_getSubscriptionTransaction','unchained'
go
