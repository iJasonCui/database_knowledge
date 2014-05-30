IF OBJECT_ID('dbo.wsp_getAccountFlagByFromToRv') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAccountFlagByFromToRv
    IF OBJECT_ID('dbo.wsp_getAccountFlagByFromToRv') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAccountFlagByFromToRv >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAccountFlagByFromToRv >>>'
END
go
 /***********************************************************************
**
** CREATION:
**   Author:  Slobodan Kandic
**   Date:  Aug 12 2003
**   Description:  Retrieves Account Flags
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getAccountFlagByFromToRv
@from DATETIME,
@to DATETIME
AS

BEGIN
	SELECT
	userId,
	reasonContentId,
	reviewed,
        adminUserId,
	dateCreated
	FROM AccountFlag
	WHERE dateCreated >= @from AND dateCreated <= @to
	ORDER BY dateCreated

	RETURN @@error
END 
 
go
GRANT EXECUTE ON dbo.wsp_getAccountFlagByFromToRv TO web
go
IF OBJECT_ID('dbo.wsp_getAccountFlagByFromToRv') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAccountFlagByFromToRv >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAccountFlagByFromToRv >>>'
go
EXEC sp_procxmode 'dbo.wsp_getAccountFlagByFromToRv','unchained'
go
