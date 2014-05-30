IF OBJECT_ID('dbo.wsp_delAccountFlagByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delAccountFlagByDate
    IF OBJECT_ID('dbo.wsp_delAccountFlagByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delAccountFlagByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delAccountFlagByDate >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 9, 2003
**   Description:  delete all AccountFlag rows older than date specified
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date:  June 19, 2006
**   Description: return numberOfDeletedRows
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_delAccountFlagByDate
@cutoffDate DATETIME

AS

DECLARE @userId        NUMERIC(12,0)
,@dateCreated          DATETIME
,@numberOfDeletedRows  INT

SELECT @numberOfDeletedRows = 0

SELECT  userId, dateCreated
INTO 	#AccountFlag
FROM 	AccountFlag
WHERE	dateCreated <= @cutoffDate
            
DECLARE AccountFlag_Cursor CURSOR FOR

SELECT  userId,dateCreated
FROM    #AccountFlag
FOR READ ONLY

OPEN  AccountFlag_Cursor

FETCH AccountFlag_Cursor
INTO  @userId,@dateCreated

WHILE (@@sqlstatus = 0)
  BEGIN
	BEGIN TRAN TRAN_delAccountFlagByDate
		DELETE AccountFlag
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

        FETCH AccountFlag_Cursor
        INTO  @userId,@dateCreated
  END

CLOSE AccountFlag_Cursor

DEALLOCATE CURSOR AccountFlag_Cursor
SELECT @numberOfDeletedRows
go
IF OBJECT_ID('dbo.wsp_delAccountFlagByDate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_delAccountFlagByDate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delAccountFlagByDate >>>'
go
GRANT EXECUTE ON dbo.wsp_delAccountFlagByDate TO web
go

