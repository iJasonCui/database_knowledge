IF OBJECT_ID('dbo.wsp_cntNewViewedMe') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntNewViewedMe
    IF OBJECT_ID('dbo.wsp_cntNewViewedMe') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntNewViewedMe >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntNewViewedMe >>>'
END
go

/******************************************************************************
 ** CREATION:
 **   Author:      Andy Tran
 **   Date:        February 2008  
 **   Description: count the number of ViewedMe to the given user, not seen yet,
 **                created after the given cutoff date.
 **
 ** REVISION(S):
 **   Author:
 **   Date:
 **   Description:
 **
******************************************************************************/
CREATE PROCEDURE wsp_cntNewViewedMe
 @targetUserId NUMERIC(12,0)
,@cutoff       DATETIME
,@cnt          INT OUTPUT
AS

BEGIN
    SELECT @cnt = COUNT(*)
      FROM ViewedMe v ( INDEX XAK1ViewedMe), a_profile_dating p
     WHERE v.targetUserId = @targetUserId
       AND v.userId = p.user_id
       AND v.dateCreated > @cutoff
       AND v.seen IN ('N', 'O')
       AND ((p.show_prefs = 'Y') OR (p.show_prefs = 'O' AND p.on_line = 'Y'))
--       AND v.userId NOT IN (SELECT targetUserId FROM Blocklist WHERE userId = @targetUserId)
    AT ISOLATION READ UNCOMMITTED  

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntNewViewedMe TO web
go

IF OBJECT_ID('dbo.wsp_cntNewViewedMe') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntNewViewedMe >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntNewViewedMe >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntNewViewedMe','unchained'
go
