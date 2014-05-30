IF OBJECT_ID('dbo.wsp_updUserSubscriptionAccount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserSubscriptionAccount
    IF OBJECT_ID('dbo.wsp_updUserSubscriptionAccount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserSubscriptionAccount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserSubscriptionAccount >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 25, 2004
**   Description:  updates user account subscription info
**
**
** REVISION(S):
**   Author: Marc Henderson
**   Date: January 21 2005
**   Description: update so that GMT time is instead of passed in dateNow which will be timezone of app server - in our case EST time.
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: January 21 2005
**   Description: fixed app so it passes in correct GMT time, so when we reverse subscription we can make expiryDate = dateNow 
**
** REVISION(S):
**   Author: Yan Liu 
**   Date: Feb 26 2008
**   Description: avoid duplication in UserSubscriptionAccountHistory 
**
** REVISION(S):
**   Author: Yan Liu 
**   Date: April 10 2008
**   Description: adjust unique index of UserSubscriptionAccount. 
**
** REVISION(S):
**   Author: Yan Liu
**   Date: June 3 2008
**   Description: Rewrite insert part to simplify business logic.
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserSubscriptionAccount
   @userId                    NUMERIC(12,0),
   @subscriptionOfferDetailId SMALLINT,
   @subscriptionStatus        CHAR(1),
   @autoRenew                 CHAR(1),
   @dateExpiry                DATETIME,
   @dateNowGMT                DATETIME,
   @cancelCodeMask            INT,
   @userCancelReason          VARCHAR(255),
   @cardId                    INT
AS

SELECT subscriptionOfferDetailId
  INTO #tmp_subSpecialOffer
  FROM UserSubscriptionAccount 
 WHERE userId = @userId  
   AND subscriptionOfferDetailId <= 0

DECLARE @sOfferDetailId2 SMALLINT

DECLARE CUR_UserSubAccount2 CURSOR FOR
SELECT subscriptionOfferDetailId 
  FROM #tmp_subSpecialOffer
   FOR READ ONLY

OPEN CUR_UserSubAccount2
FETCH CUR_UserSubAccount2 INTO @sOfferDetailId2

WHILE (@@sqlstatus != 2)
   BEGIN
      IF (@@sqlstatus = 1)
         BEGIN
            CLOSE CUR_UserSubAccount2
            DEALLOCATE CURSOR CUR_UserSubAccount2
            RETURN 84
         END

         BEGIN TRAN TRAN_delUserSubscriptionAcc2

         DELETE FROM UserSubscriptionAccount
          WHERE userId = @userId
            AND subscriptionOfferDetailId = @sOfferDetailId2

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_delUserSubscriptionAcc2
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_delUserSubscriptionAcc2
            END

         FETCH CUR_UserSubAccount2 INTO @sOfferDetailId2
   END

CLOSE CUR_UserSubAccount2
DEALLOCATE CURSOR CUR_UserSubAccount2   
   
     
IF NOT EXISTS (SELECT 1 FROM UserSubscriptionAccount 
                WHERE userId = @userId 
                  AND subscriptionOfferDetailId = @subscriptionOfferDetailId)
   BEGIN
      DECLARE @premiumId SMALLINT
      DECLARE @sOfferDetailId SMALLINT

      IF (@subscriptionOfferDetailId > 0) 
         BEGIN
            SELECT @premiumId = premiumId 
              FROM SubscriptionOfferDetail
             WHERE subscriptionOfferDetailId = @subscriptionOfferDetailId
         END
      ELSE
         BEGIN
            SELECT @premiumId = 0 
         END
         
      CREATE TABLE #tmp_subAccount
      (
         subscriptionOfferDetailId SMALLINT NOT NULL
      )

      INSERT INTO #tmp_subAccount
      SELECT u.subscriptionOfferDetailId
        FROM SubscriptionOfferDetail s, UserSubscriptionAccount u
       WHERE u.userId = @userId
         AND s.subscriptionOfferDetailId = u.subscriptionOfferDetailId 
         AND s.premiumId = @premiumId 

      DECLARE CUR_UserSubscriptionAccount CURSOR FOR
       SELECT subscriptionOfferDetailId FROM #tmp_subAccount FOR READ ONLY

      OPEN CUR_UserSubscriptionAccount
      FETCH CUR_UserSubscriptionAccount INTO @sOfferDetailId

      WHILE (@@sqlstatus != 2)
         BEGIN
            IF (@@sqlstatus = 1)
               BEGIN
                  CLOSE CUR_UserSubscriptionAccount
                  DEALLOCATE CURSOR CUR_UserSubscriptionAccount
                  RETURN 94
               END

               BEGIN TRAN TRAN_delUserSubscriptionAcc

               DELETE FROM UserSubscriptionAccount
                WHERE userId = @userId
                  AND subscriptionOfferDetailId = @sOfferDetailId

               IF (@@error = 0)
                  BEGIN
                     COMMIT TRAN TRAN_delUserSubscriptionAcc
                  END
               ELSE
                  BEGIN
                     ROLLBACK TRAN TRAN_delUserSubscriptionAcc
                  END

               FETCH CUR_UserSubscriptionAccount INTO @sOfferDetailId
         END

      CLOSE CUR_UserSubscriptionAccount
      DEALLOCATE CURSOR CUR_UserSubscriptionAccount

      BEGIN TRAN TRAN_updUserSubscriptionAcc
      INSERT INTO UserSubscriptionAccount(userId,
                                          cardId,
                                          subscriptionOfferDetailId, 
                                          subscriptionStatus,
                                          autoRenew,
                                          subscriptionEndDate,
                                          dateCreated,
                                          dateModified) 
      VALUES(@userId,
             @cardId,
             @subscriptionOfferDetailId,
             @subscriptionStatus,
             @autoRenew,
             @dateExpiry,
             @dateNowGMT,
             @dateNowGMT)

      IF (@@error != 0)
         BEGIN
            ROLLBACK TRAN TRAN_updUserSubscriptionAcc
            RETURN 95
         END

      INSERT INTO UserSubscriptionAccountHistory(userId,
                                                 cardId,
                                                 subscriptionOfferDetailId,
                                                 subscriptionStatus,
                                                 autoRenew,
                                                 subscriptionEndDate,
                                                 cancelCodeId,
                                                 userCancelReason,
                                                 dateCreated,
                                                 dateModified,
                                                 cancelCodeMask) 
      SELECT userId,
             cardId, 
             subscriptionOfferDetailId,
             subscriptionStatus,
             autoRenew,
             subscriptionEndDate,
             0,
             @userCancelReason,
             dateCreated,
             dateModified,
             @cancelCodeMask
        FROM UserSubscriptionAccount  
       WHERE userId = @userId       
         AND subscriptionOfferDetailId = @subscriptionOfferDetailId

      IF (@@error = 0)
         BEGIN
            COMMIT TRAN TRAN_updUserSubscriptionAcc
            RETURN 0 
         END
      ELSE
         BEGIN
            ROLLBACK TRAN TRAN_updUserSubscriptionAcc
            RETURN 96
         END
   END
ELSE 
   BEGIN 
   BEGIN TRAN TRAN_updUserSubscriptionAcc

   UPDATE UserSubscriptionAccount
      SET subscriptionStatus  = @subscriptionStatus,
          cardId  = @cardId,
          autoRenew = @autoRenew,
          subscriptionEndDate = @dateExpiry,
          dateModified = @dateNowGMT
    WHERE userId = @userId
      AND subscriptionOfferDetailId = @subscriptionOfferDetailId

   IF (@@error != 0)
      BEGIN
         ROLLBACK TRAN TRAN_updUserSubscriptionAcc
         RETURN 98
      END

   INSERT INTO UserSubscriptionAccountHistory(userId,
                                              cardId,
                                              subscriptionOfferDetailId,
                                              subscriptionStatus,
                                              autoRenew,
                                              subscriptionEndDate,
                                              cancelCodeId,
                                              userCancelReason,
                                              dateCreated,
                                              dateModified,
                                              cancelCodeMask) 
   SELECT userId,
          cardId,
          subscriptionOfferDetailId,
          subscriptionStatus,
          autoRenew,
          subscriptionEndDate,
          0,
          @userCancelReason,
          dateCreated,
          dateModified,
          @cancelCodeMask                 
     FROM UserSubscriptionAccount  
    WHERE userId = @userId       
      AND subscriptionOfferDetailId = @subscriptionOfferDetailId

   IF (@@error = 0)
      BEGIN
         COMMIT TRAN TRAN_updUserSubscriptionAcc
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_updUserSubscriptionAcc
         RETURN 97
      END
   END


go
EXEC sp_procxmode 'dbo.wsp_updUserSubscriptionAccount','unchained'
go
IF OBJECT_ID('dbo.wsp_updUserSubscriptionAccount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserSubscriptionAccount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserSubscriptionAccount >>>'
go
GRANT EXECUTE ON dbo.wsp_updUserSubscriptionAccount TO web
go

