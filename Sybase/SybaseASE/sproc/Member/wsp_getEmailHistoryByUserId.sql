IF OBJECT_ID('dbo.wsp_getEmailHistoryByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getEmailHistoryByUserId
    IF OBJECT_ID('dbo.wsp_getEmailHistoryByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getEmailHistoryByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getEmailHistoryByUserId >>>'
END
go
/***********************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  May 2003
**   Description:  Retrieves EmailHistory for a given user id
**
** REVISION(S):
**   Author:  Jack Veiga
**   Date:  January 2004
**   Description:  Removed join with admin table
**
** REVISION(S):
**   Author:  Yan L 
**   Date:  November 2006
**   Description:  Add bounceBackCounter column into resultset 
**
*************************************************************************/

CREATE PROCEDURE wsp_getEmailHistoryByUserId
    @userId NUMERIC(12, 0)
AS

BEGIN
    SELECT email,
           status,
           dateCreated,
           dateModified,
           modifiedBy,
           type,
           bounceBackCounter
      FROM EmailHistory
     WHERE userId = @userId
    ORDER BY dateCreated

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getEmailHistoryByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getEmailHistoryByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getEmailHistoryByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getEmailHistoryByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getEmailHistoryByUserId','unchained'
go
