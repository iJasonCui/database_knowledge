IF OBJECT_ID('dbo.wsp_getAllMerchants') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllMerchants
    IF OBJECT_ID('dbo.wsp_getAllMerchants') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.getAllMerchants >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllMerchants >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all merchants
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllMerchants
AS
  BEGIN  
	SELECT 
          merchantId,
          merchantCode,
          routingCode,
          cardProcessor,
          description
        FROM Merchant
        ORDER BY merchantId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllMerchants') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllMerchants >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllMerchants >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllMerchants TO web
go

