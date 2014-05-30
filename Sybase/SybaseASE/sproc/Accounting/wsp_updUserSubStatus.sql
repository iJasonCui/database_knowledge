IF OBJECT_ID('dbo.wsp_updUserSubStatus') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserSubStatus
    IF OBJECT_ID('dbo.wsp_updUserSubStatus') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserSubStatus >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserSubStatus >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  April 18, 2008 
**   Description:  updates user account subscription info
**
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updUserSubStatus
   @userId                    NUMERIC(12,0),
   @subscriptionOfferDetailId SMALLINT,
   @subscriptionStatus        CHAR(1),
   @autoRenew                 CHAR(1),
   @dateNow                   DATETIME
AS
     
BEGIN
   IF EXISTS(SELECT 1 FROM UserSubscriptionAccount 
              WHERE userId = @userId 
                AND subscriptionOfferDetailId = @subscriptionOfferDetailId)
      BEGIN
         BEGIN TRAN TRAN_updUserSubStatus

         UPDATE UserSubscriptionAccount
            SET subscriptionStatus  = @subscriptionStatus,
                autoRenew = @autoRenew,
                dateModified = @dateNow
          WHERE userId = @userId
            AND subscriptionOfferDetailId = @subscriptionOfferDetailId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_updUserSubStatus 
               RETURN 0 
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_updUserSubscriptionAcc
               RETURN 99
            END
      END
END
go

IF OBJECT_ID('dbo.wsp_updUserSubStatus') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserSubStatus >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserSubStatus >>>'
go

GRANT EXECUTE ON dbo.wsp_updUserSubStatus TO web
go

