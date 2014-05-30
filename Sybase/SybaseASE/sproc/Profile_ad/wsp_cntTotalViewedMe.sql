IF OBJECT_ID('dbo.wsp_cntTotalViewedMe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntTotalViewedMe
    IF OBJECT_ID('dbo.wsp_cntTotalViewedMe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntTotalViewedMe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntTotalViewedMe >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        February 2008
**   Description: retrieves total viewedMe for the target user
**
** REVISION(S):
**   Author: 
**   Date: 
**   Description:
**
******************************************************************************/
CREATE PROCEDURE wsp_cntTotalViewedMe
 @targetUserId NUMERIC(12,0)
,@cutoff       INT
AS

BEGIN
    SELECT COUNT(*)
      FROM a_profile_dating p, ViewedMe v
     WHERE v.targetUserId = @targetUserId
       AND v.userId = p.user_id
       AND ((p.show_prefs = 'Y') OR (p.show_prefs = 'O' AND p.on_line = 'Y'))
       AND p.laston > @cutoff
--       AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @targetUserId)
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END 
go

GRANT EXECUTE ON dbo.wsp_cntTotalViewedMe TO web
go

IF OBJECT_ID('dbo.wsp_cntTotalViewedMe') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntTotalViewedMe >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntTotalViewedMe >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntTotalViewedMe','unchained'
go
