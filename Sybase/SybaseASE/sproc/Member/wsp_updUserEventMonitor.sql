IF OBJECT_ID('dbo.wsp_updUserEventMonitor') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updUserEventMonitor
    IF OBJECT_ID('dbo.wsp_updUserEventMonitor') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updUserEventMonitor >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updUserEventMonitor >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          April, 2006
**   Description:   Updates user event monitor
**
** REVISION(S):
**   Author:
**   Date:
** Description:
**
*************************************************************************/

CREATE PROCEDURE  wsp_updUserEventMonitor
 @userEventId        INT
,@adminUserId        INT
AS

DECLARE
 @return             INT
,@dateGMT            DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_wsp_updUserEventMonitor
    IF EXISTS (SELECT 1 FROM UserEventMonitor WHERE userEventId = @userEventId)
        BEGIN
            UPDATE UserEventMonitor
               SET adminUserId = @adminUserId
                  ,reviewedFlag = 'Y'
                  ,dateModified = @dateGMT
             WHERE userEventId = @userEventId
            
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_wsp_updUserEventMonitor
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_wsp_updUserEventMonitor
                    RETURN 99
                END
        END
go

GRANT EXECUTE ON dbo.wsp_updUserEventMonitor TO web
go

IF OBJECT_ID('dbo.wsp_updUserEventMonitor') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updUserEventMonitor >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updUserEventMonitor >>>'
go

EXEC sp_procxmode 'dbo.wsp_updUserEventMonitor','unchained'
go
