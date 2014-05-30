IF OBJECT_ID('dbo.wsp_getUserEventMonitors') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getUserEventMonitors
    IF OBJECT_ID('dbo.wsp_getUserEventMonitors') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getUserEventMonitors >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getUserEventMonitors >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          April, 2006
**   Description:   Retrieves user event monitor by specific date period
**
** REVISION(S):
**   Author: Sean Dwyer 
**   Date: Jan 26, 2009
** Description: added messagOnHoldStatus
**
*************************************************************************/

CREATE PROCEDURE  wsp_getUserEventMonitors
 @dateFrom DATETIME
,@dateTo   DATETIME
AS

BEGIN
    SELECT m.userEventId
          ,e.userId
          ,e.eventTypeId
          ,m.reviewedFlag
          ,m.adminUserId
          ,m.dateCreated
          ,u.messageOnHoldStatus
      FROM UserEvent e, UserEventMonitor m, user_info u
     WHERE e.userEventId = m.userEventId
       AND m.dateCreated >= @dateFrom
       AND m.dateCreated <= @dateTo
       AND u.user_id=e.userId
    
    RETURN @@error
END

go
EXEC sp_procxmode 'dbo.wsp_getUserEventMonitors','unchained'
go
IF OBJECT_ID('dbo.wsp_getUserEventMonitors') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getUserEventMonitors >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getUserEventMonitors >>>'
go
GRANT EXECUTE ON dbo.wsp_getUserEventMonitors TO web
go
