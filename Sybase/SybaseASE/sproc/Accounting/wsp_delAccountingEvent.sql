
IF OBJECT_ID('dbo.wsp_delAccountingEventByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delAccountingEventByDate
    IF OBJECT_ID('dbo.wsp_delAccountingEventByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delAccountingEventByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delAccountingEventByDate >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 9, 2003
**   Description:  delete all AccountingEvent rows older than date specified
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  June 19, 2006
**   Description: return numberOfDeletedRows
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delAccountingEventByDate
@cutoffDate DATETIME

AS

DECLARE @userId        NUMERIC(12,0)
,@dateCreated          DATETIME
,@numberOfDeletedRows  INT

SELECT @numberOfDeletedRows = 0

SELECT  userId, dateCreated
INTO 	#AccountingEvent
FROM 	AccountingEvent
WHERE	dateCreated <= @cutoffDate
            
DECLARE AccountingEvent_Cursor CURSOR FOR

SELECT  userId,dateCreated
FROM    #AccountingEvent
FOR READ ONLY

OPEN  AccountingEvent_Cursor

FETCH AccountingEvent_Cursor
INTO  @userId,@dateCreated

WHILE (@@sqlstatus = 0)
  BEGIN
	BEGIN TRAN TRAN_delAccountingEventByDate
		DELETE AccountingEvent
		WHERE userId = @userId
                AND   dateCreated = @dateCreated

		IF @@error = 0
			BEGIN
			   COMMIT TRAN TRAN_delMailByDate
			END
		ELSE
			BEGIN
			   ROLLBACK TRAN TRAN_delMailByDate
			END 		

        SELECT @numberOfDeletedRows = @numberOfDeletedRows + 1

        FETCH AccountingEvent_Cursor
        INTO  @userId,@dateCreated
  END

CLOSE AccountingEvent_Cursor

DEALLOCATE CURSOR AccountingEvent_Cursor
SELECT @numberOfDeletedRows
go
IF OBJECT_ID('dbo.wsp_delAccountingEventByDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delAccountingEventByDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delAccountingEventByDate >>>'
go
GRANT EXECUTE ON dbo.wsp_delAccountingEventByDate TO web
go

