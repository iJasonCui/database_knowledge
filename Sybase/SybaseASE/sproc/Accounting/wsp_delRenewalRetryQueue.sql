IF OBJECT_ID('dbo.wsp_delRenewalRetryQueue') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delRenewalRetryQueue
    IF OBJECT_ID('dbo.wsp_delRenewalRetryQueue') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delRenewalRetryQueue >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delRenewalRetryQueue >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 25 2008 
**   Description:  delete RenewalRetryQueue 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delRenewalRetryQueue
   @userId NUMERIC(12,0)
AS

BEGIN
   IF EXISTS(SELECT 1 FROM RenewalRetryQueue WHERE userId = @userId) 
      BEGIN
         BEGIN TRAN TRAN_delRenewalRetryQueue
         DELETE FROM RenewalRetryQueue WHERE userId = @userId

         IF (@@error = 0)
            BEGIN
               COMMIT TRAN TRAN_delRenewalRetryQueue 
            END
         ELSE
            BEGIN
               ROLLBACK TRAN TRAN_delRenewalRetryQueue 
               RETURN 99
            END
      END
   RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_delRenewalRetryQueue') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delRenewalRetryQueue >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delRenewalRetryQueue >>>'
go

GRANT EXECUTE ON dbo.wsp_delRenewalRetryQueue TO web
go

