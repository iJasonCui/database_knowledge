IF OBJECT_ID('dbo.wsp_getPurchaseByXactionId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPurchaseByXactionId
    IF OBJECT_ID('dbo.wsp_getPurchaseByXactionId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPurchaseByXactionId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPurchaseByXactionId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         January 2008
**   Description:  Get purchase history for a given xactionId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getPurchaseByXactionId
 @xactionId NUMERIC(12,0)
AS

BEGIN
    SELECT userId
          ,purchaseTypeId
          ,xactionTypeId
          ,creditCardId
          ,currencyId
          ,cost
          ,tax
          ,dateCreated
      FROM Purchase
     WHERE xactionId = @xactionId
  
     RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getPurchaseByXactionId TO web
go

IF OBJECT_ID('dbo.wsp_getPurchaseByXactionId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPurchaseByXactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPurchaseByXactionId >>>'
go
