IF OBJECT_ID('dbo.wsp_getUserAccountHistForAdmin') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserAccountHistForAdmin
    IF OBJECT_ID('dbo.wsp_getUserAccountHistForAdmin') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserAccountHistForAdmin >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserAccountHistForAdmin >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 17, 2004
**   Description:  retrieves UserAccount history for the specified user
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 3, 2006
**   Description: return subcriptionOfferId
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getUserAccountHistForAdmin
 @userId NUMERIC(12,0)
,@dateCreated DATETIME
AS

SELECT billingLocationId,
accountType,
purchaseOfferId,
usageCellId,
dateExpiry,
dateModified,
"N",  -- no idea why this is here, but am afraid to remove in case this proc is used somewhere else
subscriptionOfferId
FROM UserAccountHistory
WHERE userId = @userId 
ORDER BY dateModified

RETURN @@error
go
GRANT EXECUTE ON dbo.wsp_getUserAccountHistForAdmin TO web
go
IF OBJECT_ID('dbo.wsp_getUserAccountHistForAdmin') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserAccountHistForAdmin >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserAccountHistForAdmin >>>'
go
EXEC sp_procxmode 'dbo.wsp_getUserAccountHistForAdmin','unchained'
go
