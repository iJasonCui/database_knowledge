IF OBJECT_ID('dbo.wsp_saveRenewRetryHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_saveRenewRetryHistory
    IF OBJECT_ID('dbo.wsp_saveRenewRetryHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_saveRenewRetryHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_saveRenewRetryHistory >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 29 2008 
**   Description:  save Renewal Retry History
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_saveRenewRetryHistory
   @userId        NUMERIC(12, 0), 
   @status        CHAR(1),
   @xactionId     NUMERIC(12, 0),
   @origXactionId NUMERIC(12, 0),
   @retryCounter  INT,         
   @declineCode   INT
AS

BEGIN
   DECLARE @return     INT
   DECLARE @dateNowGMT DATETIME

   EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

   BEGIN TRAN TRAN_saveRenewalRetryHistory

   IF (@xactionId > 0) 
      BEGIN
         IF NOT EXISTS(SELECT 1 FROM RenewalRetryHistory WHERE xactionId = @xactionId) 
            BEGIN
               INSERT INTO RenewalRetryHistory(userId,
                                               status, 
                                               xactionId,
                                               origXactionId,
                                               retryCounter,
                                               declineCode,
                                               dateCreated)
               VALUES(@userId, 
                      @status,
                      @xactionId,
                      @origXactionId,
                      @retryCounter,
                      @declineCode,
                      @dateNowGMT)

               IF (@@error = 0)
                  BEGIN
                     COMMIT TRAN TRAN_saveRenewalRetryHistory
                  END
               ELSE
                  BEGIN
                     ROLLBACK TRAN TRAN_saveRenewalRetryHistory
                     RETURN 99
                  END
            END
      END
   ELSE
      BEGIN
         INSERT INTO RenewalRetryHistory(userId,
                                         status,
                                         xactionId,
                                         origXactionId,
                                         retryCounter,
                                         declineCode,
                                         dateCreated)
         VALUES(@userId,
                @status,
                @xactionId,
                @origXactionId,
                @retryCounter,
                @declineCode,
                @dateNowGMT)

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_saveRenewalRetryHistory
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_saveRenewalRetryHistory
               RETURN 98
            END
      END
   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_saveRenewRetryHistory') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_saveRenewRetryHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_saveRenewRetryHistory >>>'
go

GRANT EXECUTE ON dbo.wsp_saveRenewRetryHistory TO web
go

