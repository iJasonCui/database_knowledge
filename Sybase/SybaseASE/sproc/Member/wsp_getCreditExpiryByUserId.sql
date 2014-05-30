IF OBJECT_ID('dbo.wsp_getCreditExpiryByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditExpiryByUserId
    IF OBJECT_ID('dbo.wsp_getCreditExpiryByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditExpiryByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditExpiryByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Yan L 
**   Date:  Mar 15 2004
**   Description:  Get UserCreditExpiry By userId 
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/  
CREATE PROCEDURE dbo.wsp_getCreditExpiryByUserId 
    @userId NUMERIC(12,0)
AS

BEGIN     
	SELECT DATEDIFF(SS, '19700101', dateEmailSent) 
	  FROM UserCreditExpiry 
	 WHERE userId = @userId
        ORDER BY userLastOn DESC

	RETURN @@error
END         
go

GRANT EXECUTE ON dbo.wsp_getCreditExpiryByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getCreditExpiryByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditExpiryByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditExpiryByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCreditExpiryByUserId','unchained'
go
