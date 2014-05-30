IF OBJECT_ID('dbo.wsp_getUpsellExpiry') IS NOT NULL
BEGIN
   DROP PROCEDURE dbo.wsp_getUpsellExpiry
   IF OBJECT_ID('dbo.wsp_getUpsellExpiry') IS NOT NULL
      PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUpsellExpiry >>>'
   ELSE
      PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUpsellExpiry >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  May 2 2008
**   Description:  retrieves all expired upsells, which are marked ianctive.
**
** REVISION:
**   Author:  
**   Date:   
**   Description: 
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getUpsellExpiry
AS

BEGIN
   DECLARE @return  INT
   DECLARE @dateNow DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
   IF @return != 0
   BEGIN
      RETURN @return
   END

   DECLARE CUR_upsellExpiry CURSOR FOR 
   SELECT userId, 
          subscriptionOfferDetailId  
     FROM UserSubscriptionAccount
    WHERE subscriptionStatus <> 'I'
      AND ISNULL(subscriptionEndDate, '20521231') < @dateNow
      AND autoRenew = 'N'
      AND subscriptionOfferDetailId IN(SELECT subscriptionOfferDetailId 
                                         FROM SubscriptionOfferDetail 
                                        WHERE premiumId > 0)
   ORDER BY userId ASC 

   DECLARE @userId NUMERIC(12, 0)
   DECLARE @subscriptionOfferDetailId SMALLINT

   OPEN CUR_upsellExpiry 
   FETCH CUR_upsellExpiry INTO @userId, @subscriptionOfferDetailId

   WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_upsellExpiry 
            DEALLOCATE CURSOR CUR_upsellExpiry 
            RETURN 99
         END
    
      BEGIN TRAN TRAN_insUpsellExpiry
      UPDATE UserSubscriptionAccount
         SET subscriptionStatus = 'I',
             dateModified = @dateNow
       WHERE userId = @userId
         AND subscriptionOfferDetailId = @subscriptionOfferDetailId
      
      IF (@@error = 0) 
         BEGIN
            INSERT INTO UserSubscriptionAccountHistory(userId,
                                                       cardId,
                                                       subscriptionOfferDetailId,
                                                       subscriptionStatus,
                                                       autoRenew,
                                                       subscriptionEndDate,
                                                       dateCreated,
                                                       dateModified)
            SELECT userId, 
                   cardId, 
                   subscriptionOfferDetailId,
                   subscriptionStatus,
                   autoRenew,
                   subscriptionEndDate,
                   dateCreated,
                   dateModified  
              FROM UserSubscriptionAccount
             WHERE userId = @userId
               AND subscriptionOfferDetailId = @subscriptionOfferDetailId

            IF (@@error = 0)
               BEGIN
                  COMMIT TRAN TRAN_insUpsellExpiry
               END
            ELSE
               BEGIN
                  ROLLBACK TRAN TRAN_insUpsellExpiry
               END
         END
      ELSE
         BEGIN
            ROLLBACK TRAN TRAN_insUpsellExpiry
         END
      
      FETCH CUR_upsellExpiry INTO @userId, @subscriptionOfferDetailId
   END
 
   CLOSE CUR_upsellExpiry 
   DEALLOCATE CURSOR CUR_upsellExpiry 
   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getUpsellExpiry') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUpsellExpiry >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUpsellExpiry >>>'
go

GRANT EXECUTE ON dbo.wsp_getUpsellExpiry TO web
go

