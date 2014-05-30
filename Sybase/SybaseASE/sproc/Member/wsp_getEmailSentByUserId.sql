IF OBJECT_ID('dbo.wsp_getEmailSentByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getEmailSentByUserId
    IF OBJECT_ID('dbo.wsp_getEmailSentByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getEmailSentByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getEmailSentByUserId >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author: Yan L 
**   Date:  Mar 15 2004
**   Description:  Get dateEmailSent By userId 
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/  
CREATE PROCEDURE dbo.wsp_getEmailSentByUserId 
    @userId NUMERIC(12,0)
AS

BEGIN     
	SELECT DATEDIFF(SS, '19700101', dateEmailSent),
           userLastOn 
	  FROM UserCreditExpiry 
	 WHERE userId = @userId
    ORDER BY userLastOn DESC

	RETURN @@error
END         
go

GRANT EXECUTE ON dbo.wsp_getEmailSentByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getEmailSentByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getEmailSentByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getEmailSentByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getEmailSentByUserId','unchained'
go
