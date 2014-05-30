IF OBJECT_ID('dbo.wsp_chkUserEventByTarget') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkUserEventByTarget
    IF OBJECT_ID('dbo.wsp_chkUserEventByTarget') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkUserEventByTarget >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkUserEventByTarget >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          May 2008
**   Description:   Count distinct user event for a given target
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_chkUserEventByTarget
 @userId             NUMERIC(12,0)
,@targetUserId       NUMERIC(12,0)
,@eventTypeId        SMALLINT
,@productCode        CHAR(1)
,@communityCode      CHAR(1)
,@eventMonitorCutoff DATETIME
AS

IF EXISTS (SELECT 1
             FROM UserEvent
            WHERE userId = @userId
              AND targetUserId = @targetUserId
              AND eventTypeId = @eventTypeId
              AND productCode = @productCode
              AND communityCode = @communityCode
              AND dateCreated >= @eventMonitorCutoff)
    BEGIN
        SELECT 1
    END
ELSE
    BEGIN
        SELECT 0
    END
go

GRANT EXECUTE ON dbo.wsp_chkUserEventByTarget TO web
go

IF OBJECT_ID('dbo.wsp_chkUserEventByTarget') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkUserEventByTarget >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkUserEventByTarget >>>'
go

EXEC sp_procxmode 'dbo.wsp_chkUserEventByTarget','unchained'
go
