IF OBJECT_ID('dbo.wsp_getPremiumAccountByType') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPremiumAccountByType
    IF OBJECT_ID('dbo.wsp_getPremiumAccountByType') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPremiumAccountByType >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPremiumAccountByType >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        November 3, 2005
**   Description: Returns PremiumAccount value object by type
**
** REVISION(S):
**   Author:        
**   Date:          
**   Description:   
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getPremiumAccountByType
 @userId               NUMERIC(12,0)
,@premiumAccountTypeId SMALLINT
AS

BEGIN
    SELECT pt.contentId, pa.dateExpiry
      FROM PremiumAccount pa, PremiumAccountType pt
     WHERE pa.userId = @userId
       AND pa.premiumAccountTypeId = @premiumAccountTypeId
       AND pa.premiumAccountTypeId = pt.premiumAccountTypeId

    RETURN @@error

END
go

GRANT EXECUTE ON dbo.wsp_getPremiumAccountByType TO web
go

IF OBJECT_ID('dbo.wsp_getPremiumAccountByType') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getPremiumAccountByType >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPremiumAccountByType >>>'
go

EXEC sp_procxmode 'dbo.wsp_getPremiumAccountByType','unchained'
go
