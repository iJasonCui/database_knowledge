IF OBJECT_ID('dbo.wsp_expireAccountTransactions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireAccountTransactions
    IF OBJECT_ID('dbo.wsp_expireAccountTransactions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireAccountTransactions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireAccountTransactions >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Mar 1 2006
**   Description: This proc expires old AccountTransaction records.
**
** REVISION(S):
**   Author:  Jason C.
**   Date:    Apr 25, 2006
**   Description: Cutoff Date is 400 days
******************************************************************************/

CREATE PROCEDURE wsp_expireAccountTransactions
 @cutoffDate     		DATETIME 
,@rowsModified          INT OUTPUT
AS
DECLARE 
 @userId                NUMERIC(12,0)
,@dateNow               DATETIME
,@xactionId             INT
,@return                INT

BEGIN

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
BEGIN
    RETURN @return
END

SELECT @rowsModified = 0

SELECT userId, MAX(xactionId) AS xactionIdMax
INTO   #DeleteAccountTransaction
FROM   AccountTransaction
WHERE  dateCreated < @cutoffDate and dateCreated >= dateadd(dd, -7, @cutoffDate)
GROUP BY userId

DECLARE AccountTransaction_cursor CURSOR FOR
SELECT userId, xactionIdMax 
FROM #DeleteAccountTransaction
FOR READ ONLY

OPEN  AccountTransaction_cursor

FETCH AccountTransaction_cursor INTO  @userId,@xactionId

WHILE (@@sqlstatus != 2)
BEGIN

   IF (@@sqlstatus = 1)
   BEGIN
      CLOSE AccountTransaction_cursor
      DEALLOCATE CURSOR AccountTransaction_cursor
      RETURN 93
   END
   ELSE BEGIN

      BEGIN TRAN TRAN_expireAccountTransactions

      DELETE FROM AccountTransaction WHERE userId = @userId AND dateCreated < @cutoffDate and xactionId < @xactionId 

      IF @@error != 0
      BEGIN
	     ROLLBACK TRAN TRAN_expireAccountTransactions
	     RETURN 93
      END
      ELSE BEGIN
         SELECT @rowsModified = @rowsModified + 1
         
         DELETE FROM AdminAccountTransaction WHERE userId = @userId AND dateCreated < @cutoffDate and xactionId < @xactionId 

         IF @@error != 0
         BEGIN
	        ROLLBACK TRAN TRAN_expireAccountTransactions
	        RETURN 93
         END
         ELSE BEGIN
            COMMIT TRAN TRAN_expireAccountTransactions
         END
      END
   END

   FETCH AccountTransaction_cursor INTO  @userId,@xactionId

END

CLOSE AccountTransaction_cursor
DEALLOCATE CURSOR AccountTransaction_cursor

SELECT @rowsModified

END

go
IF OBJECT_ID('dbo.wsp_expireAccountTransactions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireAccountTransactions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireAccountTransactions >>>'
go
EXEC sp_procxmode 'dbo.wsp_expireAccountTransactions','unchained'
go
