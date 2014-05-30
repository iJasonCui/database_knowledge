IF OBJECT_ID('dbo.wsp_delUserEventDaily') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delUserEventDaily
    IF OBJECT_ID('dbo.wsp_delUserEventDaily') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delUserEventDaily >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delUserEventDaily >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         April 2006
**   Description:  delete all UserEvent and UserEventMonitor rows
**                 older than retention
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delUserEventDaily

AS

DECLARE
 @userEventId          INT
,@numberOfDeletedRows  INT
,@eventTypeId          SMALLINT
,@eventRetention       TINYINT
,@dateGMT              DATETIME
,@return               INT

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

SELECT @numberOfDeletedRows = 0

SELECT userEventId
  INTO #UserEvent
  FROM UserEvent e, UserEventType t
 WHERE e.eventTypeId = t.eventTypeId
   -- AND t.eventRetention <= DATEDIFF(dd, e.dateCreated, @dateGMT)
   AND e.dateCreated <= DATEADD(dd, -1 * t.eventRetention, @dateGMT)
            
DECLARE UserEvent_Cursor CURSOR FOR

SELECT userEventId
  FROM #UserEvent
FOR READ ONLY

OPEN  UserEvent_Cursor

FETCH UserEvent_Cursor
 INTO @userEventId

WHILE (@@sqlstatus = 0)
    BEGIN
        BEGIN TRAN TRAN_delUserEventDaily
            DELETE UserEvent
             WHERE userEventId = @userEventId

        IF @@error = 0
            BEGIN
                IF EXISTS (SELECT 1 FROM UserEventMonitor WHERE userEventId = @userEventId)
                    BEGIN
                        DELETE UserEventMonitor
                         WHERE userEventId = @userEventId
                
                        IF @@error = 0
                            BEGIN
                                COMMIT TRAN TRAN_delUserEventDaily
                            END
                        ELSE
                            BEGIN
                                ROLLBACK TRAN TRAN_delUserEventDaily
                            END
                    END
                ELSE
                    BEGIN
                        COMMIT TRAN TRAN_delUserEventDaily
                    END
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_delUserEventDaily
            END

        SELECT @numberOfDeletedRows = @numberOfDeletedRows + 1

        FETCH UserEvent_Cursor
         INTO @userEventId
    END

CLOSE UserEvent_Cursor

DEALLOCATE CURSOR UserEvent_Cursor
go

IF OBJECT_ID('dbo.wsp_delUserEventDaily') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delUserEventDaily >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delUserEventDaily >>>'
go

GRANT EXECUTE ON dbo.wsp_delUserEventDaily TO web
go
