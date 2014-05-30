IF OBJECT_ID('dbo.wsp_getUserEventByActionCode') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserEventByActionCode
    IF OBJECT_ID('dbo.wsp_getUserEventByActionCode') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserEventByActionCode >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserEventByActionCode >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          December 2007
**   Description:   Get distinct user event by a given action code
**
** REVISION(S):
**   Author:        Andy Tran
**   Date:          May 2008
**   Description:   Change monitor to separate by products/communities
**                  Application will decide if monitor is based on
**                  products/communities by passing in the parameters
**                  (null means combine)
**
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserEventByActionCode
 @userId             NUMERIC(12,0)
,@actionCode         CHAR(1)
,@eventTypeId        SMALLINT
,@productCode        CHAR(1)
,@communityCode      CHAR(1)
,@eventMonitorCutoff DATETIME
AS

BEGIN
    SELECT e.targetUserId, e.reasonTypeId
      FROM UserEvent e, UserEventReasonType r
     WHERE e.userId = @userId
       AND e.eventTypeId = @eventTypeId
       AND e.productCode = @productCode
       AND e.communityCode = @communityCode
       AND e.dateCreated >= @eventMonitorCutoff
       AND e.reasonTypeId = r.reasonTypeId
       AND r.actionCode = @actionCode

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getUserEventByActionCode TO web
go

IF OBJECT_ID('dbo.wsp_getUserEventByActionCode') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserEventByActionCode >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserEventByActionCode >>>'
go

EXEC sp_procxmode 'dbo.wsp_getUserEventByActionCode','unchained'
go
