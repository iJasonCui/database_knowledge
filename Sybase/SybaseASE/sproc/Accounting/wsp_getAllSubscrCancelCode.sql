IF OBJECT_ID('dbo.wsp_getAllSubscrCancelCodes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllSubscrCancelCodes
    IF OBJECT_ID('dbo.wsp_getAllSubscrCancelCodes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllSubscrCancelCodes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllSubscrCancelCodes >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 2004
**   Description:  retrieves all subscription cancel codes
**
** REVISION(S):
**   Author:  Mike Stairs
**   Date:    Mar 1, 2006
**   Description: also return cancelCodeMaskId
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllSubscrCancelCodes
AS
  BEGIN  
	SELECT 
          cancelCodeId,
          contentId,
          customerChoice,
          description,
          cancelCodeMaskId
        FROM SubscriptionCancelCode
        ORDER BY ordinal 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllSubscrCancelCodes') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllSubscrCancelCodes >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllSubscrCancelCodes >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllSubscrCancelCodes TO web
go

