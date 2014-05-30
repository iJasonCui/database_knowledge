IF OBJECT_ID('dbo.wsp_newUserEvent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newUserEvent
    IF OBJECT_ID('dbo.wsp_newUserEvent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newUserEvent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newUserEvent >>>'
END
go

/***********************************************************************
**
** CREATION:
**   Author:        Andy Tran
**   Date:          April, 2006
**   Description:   Creates new user event
**
** REVISION(S):
**   Author:        Andy Tran
**   Date:          November, 2007
**   Description:   Change monitor to combine all products/communities
**                  Change return value after a sucessful monitor
**                  Add read uncommitted for select count(*)
**
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

CREATE PROCEDURE  wsp_newUserEvent
 @userId             NUMERIC(12,0)
,@targetUserId       NUMERIC(12,0)
,@eventTypeId        SMALLINT
,@reasonTypeId       SMALLINT
,@productCode        CHAR(1)
,@communityCode      CHAR(1)
,@eventMonitorLimit  TINYINT
,@eventMonitorCutoff DATETIME
AS

DECLARE
 @return             INT
,@userEventId        INT
,@dateGMT            DATETIME
,@eventMonitorCount  TINYINT

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF @targetUserId < 0
    BEGIN
        SELECT @targetUserId = NULL
    END

IF @reasonTypeId < 0
    BEGIN
        SELECT @reasonTypeId = NULL
    END

BEGIN TRAN TRAN_wsp_newUserEvent

IF NOT EXISTS (SELECT 1
                 FROM UserEvent e, UserEventMonitor m
                WHERE e.userId = @userId
                  AND e.eventTypeId = @eventTypeId
                  AND e.productCode = @productCode
                  AND e.communityCode = @communityCode
                  AND e.userEventId = m.userEventId
                  AND m.dateCreated >= @eventMonitorCutoff)
    BEGIN
        EXEC @return = dbo.wsp_UserEventId @userEventId OUTPUT
        IF @return != 0
            BEGIN
                RETURN @return
            END

        INSERT INTO UserEvent
        (
             userEventId
            ,userId
            ,targetUserId
            ,eventTypeId
            ,reasonTypeId
            ,productCode
            ,communityCode
            ,dateCreated
        )
        VALUES
        (
             @userEventId
            ,@userId
            ,@targetUserId
            ,@eventTypeId
            ,@reasonTypeId
            ,@productCode
            ,@communityCode
            ,@dateGMT
        )

        IF @@error = 0
            BEGIN
                SELECT @eventMonitorCount = count(*)
                  FROM UserEvent
                 WHERE userId = @userId
                   AND eventTypeId = @eventTypeId
                   AND productCode = @productCode
                   AND communityCode = @communityCode
                   AND dateCreated > @eventMonitorCutoff
                AT ISOLATION READ UNCOMMITTED

                IF @eventMonitorCount >= @eventMonitorLimit
                    BEGIN
                        INSERT INTO UserEventMonitor
                        (
                             userEventId
                            ,dateCreated
                            ,dateModified
                        )
                        VALUES
                        (
                             @userEventId
                            ,@dateGMT
                            ,@dateGMT
                        )

                        IF @@error = 0
                            BEGIN
                                COMMIT TRAN TRAN_wsp_newUserEvent
                                RETURN 1
                            END
                        ELSE
                            BEGIN
                                ROLLBACK TRAN TRAN_wsp_newUserEvent
                                RETURN 99
                            END
                    END
                ELSE
                    BEGIN
                        COMMIT TRAN TRAN_wsp_newUserEvent
                        RETURN 0
                    END
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_wsp_newUserEvent
                RETURN 98
            END
    END
ELSE
    BEGIN
        COMMIT TRAN TRAN_wsp_newUserEvent
        RETURN 0
    END
go

IF OBJECT_ID('dbo.wsp_newUserEvent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newUserEvent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newUserEvent >>>'
go

EXEC sp_procxmode 'dbo.wsp_newUserEvent','unchained'
go

GRANT EXECUTE ON dbo.wsp_newUserEvent TO web
go
