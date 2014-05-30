IF OBJECT_ID('dbo.wsp_getAllUserEventReasonTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllUserEventReasonTypes
    IF OBJECT_ID('dbo.wsp_getAllUserEventReasonTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllUserEventReasonTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllUserEventReasonTypes >>>'
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
**   Author:        Andy Tran
**   Date:          December, 2007
**   Description:   added actionCode
**
**   Author:
**   Date:
**   Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_getAllUserEventReasonTypes
AS

BEGIN
    SELECT reasonTypeId
          ,reasonTypeDesc
          ,contentId
          ,actionCode
      FROM UserEventReasonType
    ORDER BY reasonTypeId
    
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getAllUserEventReasonTypes TO web
go

IF OBJECT_ID('dbo.wsp_getAllUserEventReasonTypes') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllUserEventReasonTypes >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllUserEventReasonTypes >>>'
go

EXEC sp_procxmode 'dbo.wsp_getAllUserEventReasonTypes','unchained'
go
