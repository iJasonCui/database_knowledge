IF OBJECT_ID('dbo.wsp_getRenewalRetryByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRenewalRetryByUserId
    IF OBJECT_ID('dbo.wsp_getRenewalRetryByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRenewalRetryByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRenewalRetryByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:  Yan Liu 
**   Date:  July 28 2008 
**   Description:  get RenewalRetryQueue by userId 
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getRenewalRetryByUserId
   @userId NUMERIC(12,0),
   @subscriptionOfferDetailId int 
AS

BEGIN
   SELECT status,
          retryCounter,
          nextRetryDate,
          origXactionId,
          subscriptionOfferDetailId 
     FROM RenewalRetryQueue
    WHERE userId = @userId AND subscriptionOfferDetailId=@subscriptionOfferDetailId

   RETURN @@error 
END
go

IF OBJECT_ID('dbo.wsp_getRenewalRetryByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRenewalRetryByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRenewalRetryByUserId >>>'
go

GRANT EXECUTE ON dbo.wsp_getRenewalRetryByUserId TO web
go

