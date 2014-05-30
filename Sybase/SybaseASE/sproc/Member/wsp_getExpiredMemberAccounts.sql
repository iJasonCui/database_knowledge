IF OBJECT_ID('dbo.wsp_getExpiredMemberAccounts') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getExpiredMemberAccounts
    IF OBJECT_ID('dbo.wsp_getExpiredMemberAccounts') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getExpiredMemberAccounts >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getExpiredMemberAccounts >>>'
END
go
  /***********************************************************************
**
** CREATION:
**   Author: Mike Stairs
**   Date: Jan 4, 2005
**   Description: retrieve list of userIds to be archived
**
*************************************************************************/

CREATE PROCEDURE  wsp_getExpiredMemberAccounts
@inactiveExpireDaysAgo INT,
@freeExpireDaysAgo INT,
@pendingExpireDaysAgo INT,
@rowCount INT
AS


DECLARE @now INT
BEGIN

SELECT @now = datediff(ss,"Dec 31 20:00 1969",getdate())

SET ROWCOUNT @rowCount

SELECT user_id, 
       gender
FROM user_info
WHERE status = 'J'
      OR (status = 'I' AND  laston <  (@now  - (@inactiveExpireDaysAgo * 24 * 3600)))
      OR (status in ('A','M','C') AND user_type = 'F' AND laston < (@now - (@freeExpireDaysAgo * 24 * 3600)))
      OR (status in ('P','U') AND laston < (@now - (@pendingExpireDaysAgo * 24 * 3600)))

AT ISOLATION READ UNCOMMITTED
RETURN @@error
END

go
IF OBJECT_ID('dbo.wsp_getExpiredMemberAccounts') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getExpiredMemberAccounts >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getExpiredMemberAccounts >>>'
go
EXEC sp_procxmode 'dbo.wsp_getExpiredMemberAccounts','unchained'
go
GRANT EXECUTE ON dbo.wsp_getExpiredMemberAccounts TO web
go

