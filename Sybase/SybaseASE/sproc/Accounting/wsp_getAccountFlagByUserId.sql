IF OBJECT_ID('dbo.wsp_getAccountFlagByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountFlagByUserId
    IF OBJECT_ID('dbo.wsp_getAccountFlagByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountFlagByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountFlagByUserId >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:  June 7 2008
**   Description:  Retrieves Account Flags
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getAccountFlagByUserId
@userId numeric(12,0)
AS

BEGIN
	SELECT
	userId,
	reasonContentId,
	reviewed,
    adminUserId,
	dateCreated
	FROM AccountFlag
	WHERE userId = @userId  and reviewed <> 'Y'
	ORDER BY dateCreated

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getAccountFlagByUserId TO web
go
IF OBJECT_ID('dbo.wsp_getAccountFlagByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountFlagByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountFlagByUserId >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAccountFlagByUserId','unchained'
go
