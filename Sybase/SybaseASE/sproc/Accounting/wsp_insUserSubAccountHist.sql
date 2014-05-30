IF OBJECT_ID('dbo.wsp_insUserSubAccountHist') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_insUserSubAccountHist
    IF OBJECT_ID('dbo.wsp_insUserSubAccountHist') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_insUserSubAccountHist >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_insUserSubAccountHist >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 16, 2008
**   Description:  save UserSubscriptionAccountHistory 
**
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_insUserSubAccountHist
   @userId                    NUMERIC(12,0),
   @cardId                    INT,
   @subscriptionOfferDetailId SMALLINT,
   @subscriptionStatus        CHAR(1),
   @subscriptionEndDate       DATETIME,
   @autoRenew                 CHAR(1),
   @cancelCodeId              TINYINT,
   @cancelCodeMask            INT,
   @userCancelReason          VARCHAR(255),
   @dateNow                   DATETIME
AS
     
BEGIN 
   BEGIN TRAN TRAN_insUserSubAccountHist

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
   VALUES(@userId,
          @cardId,
          @subscriptionOfferDetailId,
          @subscriptionStatus,
          @autoRenew,
          @subscriptionEndDate,
          @cancelCodeId,
          @userCancelReason,
          @dateNow,
          @dateNow,
          @cancelCodeMask)                 

   IF @@error = 0
      BEGIN
         COMMIT TRAN TRAN_insUserSubAccountHist 
         RETURN 0
      END
   ELSE
      BEGIN
         ROLLBACK TRAN TRAN_insUserSubAccountHist 
         RETURN 99
      END
   END
go

IF OBJECT_ID('dbo.wsp_insUserSubAccountHist') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_insUserSubAccountHist >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_insUserSubAccountHist >>>'
go

GRANT EXECUTE ON dbo.wsp_insUserSubAccountHist TO web
go

