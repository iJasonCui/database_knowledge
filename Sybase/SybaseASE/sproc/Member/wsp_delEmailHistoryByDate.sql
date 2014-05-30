IF OBJECT_ID('dbo.wsp_delEmailHistoryByDate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delEmailHistoryByDate
    IF OBJECT_ID('dbo.wsp_delEmailHistoryByDate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delEmailHistoryByDate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delEmailHistoryByDate >>>'
END
go
 /******************************************************************************
**
** CREATION:
**   Author:  Jack Veiga/Yan Liu
**   Date:  June 2003
**   Description:  Deletes email history rows by date
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_delEmailHistoryByDate
 @numberOfDays INT
,@rowcount     INT
AS
DECLARE @dateExpiry  DATETIME
,@dateCreated 		 DATETIME
,@userId			 NUMERIC(12,0)
,@email				 VARCHAR(129)
,@deleteCount 		 INT

SELECT @dateExpiry = DATEADD(DAY,-1*@numberOfDays,GETDATE())
SELECT @deleteCount = 0

SET ROWCOUNT @rowcount

SELECT dateCreated,userId,email 
INTO #EmailHistory
FROM EmailHistory
WHERE dateCreated < @dateExpiry

SET ROWCOUNT 0

DECLARE EmailHistory_cursor CURSOR FOR

SELECT dateCreated,userId,email
FROM #EmailHistory
FOR READ ONLY

OPEN  EmailHistory_cursor

FETCH EmailHistory_cursor
INTO  @dateCreated,@userId,@email

IF (@@sqlstatus = 2)
BEGIN
    CLOSE EmailHistory_cursor
    RETURN
END

/* if cursor result set is not empty, then process each row of information */
WHILE (@@sqlstatus = 0)
BEGIN

	DELETE EmailHistory WHERE dateCreated = @dateCreated AND userId = @userId AND email = @email

	SELECT @deleteCount = @deleteCount + 1

	FETCH EmailHistory_cursor
	INTO  @dateCreated,@userId,@email

END

CLOSE EmailHistory_cursor

DEALLOCATE CURSOR EmailHistory_cursor

SELECT @deleteCount

 
go
GRANT EXECUTE ON dbo.wsp_delEmailHistoryByDate TO web
go
IF OBJECT_ID('dbo.wsp_delEmailHistoryByDate') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delEmailHistoryByDate >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delEmailHistoryByDate >>>'
go
EXEC sp_procxmode 'dbo.wsp_delEmailHistoryByDate','unchained'
go
