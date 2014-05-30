IF OBJECT_ID('dbo.wsp_getAllDefaultUserAccounts') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllDefaultUserAccounts
    IF OBJECT_ID('dbo.wsp_getAllDefaultUserAccounts') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllDefaultUserAccounts >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllDefaultUserAccounts >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all default user accounts
**
**
** REVISION(S):
**   Author:        Andy Tran
**   Date:          June 9, 2004
**   Description:   Added ORDER BY billingLocationId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllDefaultUserAccounts
AS
  BEGIN  
	SELECT 
          billingLocationId,
          defaultAccountType,
          defaultPurchaseOfferId,
          defaultUsageCellId,
          defaultSubscriptionOfferId
        FROM DefaultUserAccount
        ORDER BY billingLocationId
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllDefaultUserAccounts') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllDefaultUserAccounts >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllDefaultUserAccounts >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllDefaultUserAccounts TO web
go

