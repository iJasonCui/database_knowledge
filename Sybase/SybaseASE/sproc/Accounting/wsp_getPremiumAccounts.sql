IF OBJECT_ID('dbo.wsp_getPremiumAccounts') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPremiumAccounts
    IF OBJECT_ID('dbo.wsp_getPremiumAccounts') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPremiumAccounts >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPremiumAccounts >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 3, 2005
**   Description: Returns PremiumAccount value objects
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getPremiumAccounts
 @userId NUMERIC(12,0)
AS

BEGIN
    SELECT pa.premiumAccountTypeId, pt.contentId, pa.dateExpiry
      FROM PremiumAccount pa, PremiumAccountType pt
     WHERE pa.userId = @userId
       AND pa.premiumAccountTypeId = pt.premiumAccountTypeId

    RETURN @@error

END
go

GRANT EXECUTE ON dbo.wsp_getPremiumAccounts TO web
go

IF OBJECT_ID('dbo.wsp_getPremiumAccounts') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPremiumAccounts >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPremiumAccounts >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPremiumAccounts','unchained'
go
