IF OBJECT_ID('dbo.wsp_expireUserAccountHistory') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireUserAccountHistory
    IF OBJECT_ID('dbo.wsp_expireUserAccountHistory') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireUserAccountHistory >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireUserAccountHistory >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 2006
**   Description: This proc expires old UserAccountHistory records
**
******************************************************************************/

CREATE PROCEDURE wsp_expireUserAccountHistory
@cutoffDate     		DATETIME 
,@rowCount                      INT
,@rowsModified                  INT OUTPUT
AS
DECLARE 
@dateModified                    DATETIME
,@return                        INT
,@userId			INT

BEGIN

SET ROWCOUNT @rowCount
SELECT userId, dateModified 
INTO #DeleteUserAccountHistory
FROM UserAccountHistory
WHERE  
dateModified < @cutoffDate and dateModified >= dateadd(dd, -7 , @cutoffDate) 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE UserAccountHistory_cursor CURSOR FOR
SELECT userId, dateModified 
FROM #DeleteUserAccountHistory
FOR READ ONLY

OPEN  UserAccountHistory_cursor

FETCH UserAccountHistory_cursor
INTO  @userId, @dateModified

IF (@@sqlstatus = 2)
BEGIN
    CLOSE UserAccountHistory_cursor
    DEALLOCATE CURSOR UserAccountHistory_cursor
    RETURN 91
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireUserAccountHistory

    DELETE FROM UserAccountHistory WHERE userId = @userId AND dateModified=@dateModified

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireUserAccountHistory
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireUserAccountHistory
	 RETURN 91
    END
FETCH UserAccountHistory_cursor
INTO  @userId, @dateModified

END
CLOSE UserAccountHistory_cursor
DEALLOCATE CURSOR UserAccountHistory_cursor
SELECT @rowsModified
END 

go
GRANT EXECUTE ON dbo.wsp_expireUserAccountHistory TO web
go
IF OBJECT_ID('dbo.wsp_expireUserAccountHistory') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireUserAccountHistory >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireUserAccountHistory >>>'
go

