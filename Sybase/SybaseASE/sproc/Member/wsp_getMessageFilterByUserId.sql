IF OBJECT_ID('dbo.wsp_getMessageFilterByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getMessageFilterByUserId
    IF OBJECT_ID('dbo.wsp_getMessageFilterByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getMessageFilterByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getMessageFilterByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         August 2011
**   Description:  Select columns from MessageFilter for a given userId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getMessageFilterByUserId
@userId NUMERIC(12,0)
AS

BEGIN
    SELECT  filterParams
           ,status
           ,dateExpiry
      FROM MessageFilter
    WHERE userId = @userId
END 
go

GRANT EXECUTE ON dbo.wsp_getMessageFilterByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getMessageFilterByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getMessageFilterByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getMessageFilterByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getMessageFilterByUserId','unchained'
go
