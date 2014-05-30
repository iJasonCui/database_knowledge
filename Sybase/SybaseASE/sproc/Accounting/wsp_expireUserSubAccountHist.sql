IF OBJECT_ID('dbo.wsp_expireUserSubAccountHist') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireUserSubAccountHist
    IF OBJECT_ID('dbo.wsp_expireUserSubAccountHist') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireUserSubAccountHist >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireUserSubAccountHist >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 2006
**   Description: This proc expires old UserSubscriptionAccountHistory records
**
******************************************************************************/

CREATE PROCEDURE wsp_expireUserSubAccountHist
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
INTO #DeleteUserSubAccountHistory
FROM UserSubscriptionAccountHistory
WHERE  
dateModified < @cutoffDate 
SET ROWCOUNT 0

DECLARE UserSubAccountHistory_cursor CURSOR FOR
SELECT userId, dateModified 
FROM #DeleteUserSubAccountHistory

OPEN  UserSubAccountHistory_cursor

FETCH UserSubAccountHistory_cursor
INTO  @userId, @dateModified

IF (@@sqlstatus = 2)
BEGIN
    CLOSE UserSubAccountHistory_cursor
    DEALLOCATE CURSOR UserSubAccountHistory_cursor
    RETURN 90
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireUserSubAccountHist

    DELETE FROM UserSubscriptionAccountHistory WHERE userId = @userId AND dateModified=@dateModified

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireUserSubAccountHist
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireUserSubAccountHist
	 RETURN 90
    END
FETCH UserSubAccountHistory_cursor
INTO  @userId, @dateModified

END
CLOSE UserSubAccountHistory_cursor
DEALLOCATE CURSOR UserSubAccountHistory_cursor
SELECT @rowsModified
END

go
GRANT EXECUTE ON dbo.wsp_expireUserSubAccountHist TO web
go
IF OBJECT_ID('dbo.wsp_expireUserSubAccountHist') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireUserSubAccountHist >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireUserSubAccountHist >>>'
go

