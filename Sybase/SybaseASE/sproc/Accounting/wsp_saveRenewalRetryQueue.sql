IF OBJECT_ID('dbo.wsp_saveRenewalRetryQueue') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveRenewalRetryQueue
    IF OBJECT_ID('dbo.wsp_saveRenewalRetryQueue') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveRenewalRetryQueue >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveRenewalRetryQueue >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 25 2008 
**   Description:  save RenewalRetryQueue 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveRenewalRetryQueue
   @userId        NUMERIC(12, 0),
   @status        CHAR(1),
   @origXactionId NUMERIC(12, 0),
   @retryCounter  INT,
   @nextRetryDate DATETIME,
   @subscriptionOfferDetailId INT
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   BEGIN TRAN TRAN_saveRenewalRetryQueue

   IF EXISTS(SELECT 1 FROM RenewalRetryQueue WHERE userId = @userId and subscriptionOfferDetailId = @subscriptionOfferDetailId) 
      BEGIN
         UPDATE RenewalRetryQueue
            SET status        = @status,
                origXactionId = @origXactionId,
                retryCounter  = @retryCounter,
                nextRetryDate = @nextRetryDate,
                dateModified  = @dateNowGMT,
                subscriptionOfferDetailId = @subscriptionOfferDetailId
          WHERE userId = @userId AND subscriptionOfferDetailId = @subscriptionOfferDetailId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveRenewalRetryQueue 
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveRenewalRetryQueue 
               RETURN 99
            END
      END
   ELSE
      BEGIN
         INSERT INTO RenewalRetryQueue(userId,
                                       status,
                                       origXactionId,
                                       subscriptionOfferDetailId,
                                       retryCounter,
                                       nextRetryDate,
                                       dateCreated,
                                       dateModified)
         VALUES(@userId, 
                @status,
                @origXactionId,
                @subscriptionOfferDetailId,
                @retryCounter,
                @nextRetryDate,
                @dateNowGMT,
                @dateNowGMT)

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveRenewalRetryQueue
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveRenewalRetryQueue
               RETURN 98
            END
      END

   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveRenewalRetryQueue') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveRenewalRetryQueue >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveRenewalRetryQueue >>>'
go

GRANT EXECUTE ON dbo.wsp_saveRenewalRetryQueue TO web
go

