IF OBJECT_ID('dbo.wsp_saveSubTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveSubTransaction
    IF OBJECT_ID('dbo.wsp_saveSubTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveSubTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveSubTransaction >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 11 2008 
**   Description:  save subscription transaction 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveSubTransaction
   @xactionId                 INT,
   @creditCardId              INT,
   @userId                    NUMERIC(12,0),
   @xactionTypeId             TINYINT,
   @contentId                 SMALLINT,
   @subscriptionTypeId        SMALLINT,
   @duration                  SMALLINT,
   @userTrans                 BIT, 
   @description               VARCHAR(255),
   @durationUnit              CHAR(1),
   @dateNow                   DATETIME,
   @subscriptionOfferDetailId INT
AS

BEGIN
   BEGIN TRAN TRAN_saveSubTransaction
   INSERT INTO SubscriptionTransaction(xactionId,
                                       cardId,
                                       userId,
                                       xactionTypeId,
                                       contentId,
                                       subscriptionTypeId,
                                       duration,
                                       userTrans,
                                       description,
                                       dateCreated,
                                       durationUnits,
                                       subscriptionOfferDetailId)
   VALUES(@xactionId,
          @creditCardId,
          @userId,
          @xactionTypeId,
          @contentId,
          @subscriptionTypeId,
          @duration,
          @userTrans,
          @description,
          @dateNow,
          @durationUnit,
          @subscriptionOfferDetailId)

   IF (@@error = 0)
      BEGIN
         COMMIT TRAN TRAN_saveSubTransaction
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_saveSubTransaction
         RETURN 99
      END
END
go

IF OBJECT_ID('dbo.wsp_saveSubTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveSubTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveSubTransaction >>>'
go

GRANT EXECUTE ON dbo.wsp_saveSubTransaction TO web
go

