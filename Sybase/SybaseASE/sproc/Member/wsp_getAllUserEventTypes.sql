IF OBJECT_ID('dbo.wsp_getAllUserEventTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllUserEventTypes
    IF OBJECT_ID('dbo.wsp_getAllUserEventTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllUserEventTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllUserEventTypes >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          April, 2006
**   Description:   Retrieves all user event types
**
** REVISION(S):
**   Author:
**   Date:
** Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getAllUserEventTypes
AS

BEGIN
    SELECT eventTypeId
          ,eventTypeDesc
          ,eventMonitorLimit
          ,eventMonitorDuration
          ,eventMonitorUnit
      FROM UserEventType
    ORDER BY eventTypeId
    
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getAllUserEventTypes TO web
go

IF OBJECT_ID('dbo.wsp_getAllUserEventTypes') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllUserEventTypes >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllUserEventTypes >>>'
go

EXEC sp_procxmode 'dbo.wsp_getAllUserEventTypes','unchained'
go
