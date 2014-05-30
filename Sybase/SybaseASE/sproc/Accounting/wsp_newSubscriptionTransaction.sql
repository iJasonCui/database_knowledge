
IF OBJECT_ID('dbo.wsp_newSubscriptionTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newSubscriptionTransaction
    IF OBJECT_ID('dbo.wsp_newSubscriptionTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newSubscriptionTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newSubscriptionTransaction >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 25, 20043
**   Description:  add subscription transaction  for user
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Jan 12, 2006
**   Description: added durationUnits
**
** REVISION(S):
**   Author: Yan Liu 
**   Date: April 26, 2008
**   Description: added subscriptionOfferDetailId 
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newSubscriptionTransaction
   @userId             NUMERIC(12,0),
   @xactionTypeId      TINYINT,
   @subscriptionTypeId TINYINT,
   @contentId          SMALLINT,
   @dateNow            DATETIME,
   @adminUserId        INT,
   @description        VARCHAR(255),
   @cardId             INT,
   @duration           INT,
   @userTrans          BIT,
   @durationUnits      CHAR(1),
   @offerDetailId      SMALLINT
AS

DECLARE @return     INT,
        @return1    INT,
        @xactionId  INT,
        @dateNowGMT DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT
EXEC @return1 = dbo.wsp_XactionId @xactionId OUTPUT
   
IF @return1 != 0
   BEGIN
      RETURN @return1
   END

BEGIN TRAN TRAN_newSubscriptionTransact
   IF (@adminUserId > 0)
      BEGIN
         INSERT INTO AdminAccountTransaction(xactionId, adminUserId, userId, dateCreated) 
         VALUES (@xactionId, @adminUserId, @userId, @dateNowGMT)

         IF (@@error > 0)
            BEGIN
               ROLLBACK TRAN TRAN_purchaseCredit
               RETURN 98
            END
       END

   INSERT INTO SubscriptionTransaction(xactionId,
                                       userId,
                                       cardId,
                                       xactionTypeId,
                                       contentId,
                                       subscriptionTypeId,
                                       dateCreated,
                                       description,
                                       duration,
                                       userTrans,
                                       durationUnits,
                                       subscriptionOfferDetailId)
   VALUES(@xactionId,
          @userId,
          @cardId,
          @xactionTypeId,
          @contentId,
          @subscriptionTypeId,
          @dateNowGMT,
          @description,
          @duration,
          @userTrans,
          @durationUnits,
          @offerDetailId)
        
   IF (@@error = 0) 
      BEGIN
         COMMIT TRAN TRAN_newSubscriptionTransact
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_newSubscriptionTransact
         RETURN 98
      END
go

IF OBJECT_ID('dbo.wsp_newSubscriptionTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newSubscriptionTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newSubscriptionTransaction >>>'
go

GRANT EXECUTE ON dbo.wsp_newSubscriptionTransaction TO web
go
