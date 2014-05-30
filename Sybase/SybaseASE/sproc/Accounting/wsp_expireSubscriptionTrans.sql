IF OBJECT_ID('dbo.wsp_expireSubscriptionTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireSubscriptionTrans
    IF OBJECT_ID('dbo.wsp_expireSubscriptionTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireSubscriptionTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireSubscriptionTrans >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Mar 1 2006
**   Description: This proc expires old transaction records.
**
******************************************************************************/

CREATE PROCEDURE wsp_expireSubscriptionTrans
@cutoffDate     		DATETIME 
,@rowCount                      INT
,@rowsModified                  INT OUTPUT
AS
DECLARE 
@xactionId			INT

BEGIN
SELECT @rowsModified = 0

SET ROWCOUNT @rowCount
SELECT xactionId 
INTO #DeleteSubscriptionTransaction
FROM SubscriptionTransaction
WHERE  
dateCreated < @cutoffDate 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE SubscriptionTransaction_cursor CURSOR FOR
SELECT xactionId 
FROM #DeleteSubscriptionTransaction

OPEN  SubscriptionTransaction_cursor

FETCH SubscriptionTransaction_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE SubscriptionTransaction_cursor
    DEALLOCATE CURSOR SubscriptionTransaction_cursor
    RETURN 94
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireSubscriptionTrans

    DELETE FROM SubscriptionTransaction WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireSubscriptionTrans
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireSubscriptionTrans
	 RETURN 94
    END

FETCH SubscriptionTransaction_cursor
INTO  @xactionId

END
CLOSE SubscriptionTransaction_cursor
DEALLOCATE CURSOR SubscriptionTransaction_cursor
SELECT @rowsModified
END

go
GRANT EXECUTE ON dbo.wsp_expireSubscriptionTrans TO web
go
IF OBJECT_ID('dbo.wsp_expireSubscriptionTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireSubscriptionTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireSubscriptionTrans >>>'
go

