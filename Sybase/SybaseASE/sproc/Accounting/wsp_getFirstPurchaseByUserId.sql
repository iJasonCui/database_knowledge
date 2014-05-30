IF OBJECT_ID('dbo.wsp_getFirstPurchaseByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFirstPurchaseByUserId
    IF OBJECT_ID('dbo.wsp_getFirstPurchaseByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFirstPurchaseByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFirstPurchaseByUserId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Yan L 
**   Date:         Oct 3 2008
**   Description:  Get first purchase history for a given user 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getFirstPurchaseByUserId
   @userId NUMERIC(12,0)
AS

BEGIN
   SELECT xactionId,
          creditCardId,
          currencyId,
          cost,
          tax,
          dateCreated
     FROM Purchase
    WHERE xactionId = (SELECT min(xactionId) FROM Purchase
                        WHERE userId = @userId 
                          AND cost > 0) 
  
     RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getFirstPurchaseByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getFirstPurchaseByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFirstPurchaseByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFirstPurchaseByUserId >>>'
go
