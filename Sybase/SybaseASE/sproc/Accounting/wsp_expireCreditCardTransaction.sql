IF OBJECT_ID('dbo.wsp_expireCreditCardTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireCreditCardTransaction
    IF OBJECT_ID('dbo.wsp_expireCreditCardTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireCreditCardTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireCreditCardTransaction >>>'
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

CREATE PROCEDURE wsp_expireCreditCardTransaction
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
INTO #DeleteCreditCardTransaction
FROM CreditCardTransaction
WHERE  
dateCreated < @cutoffDate 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE CreditCardTransaction_cursor CURSOR FOR
SELECT xactionId 
FROM #DeleteCreditCardTransaction
FOR READ ONLY

OPEN  CreditCardTransaction_cursor

FETCH CreditCardTransaction_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditCardTransaction_cursor
    DEALLOCATE CURSOR CreditCardTransaction_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireCreditCardTransaction

    DELETE FROM CreditCardTransaction WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireCreditCardTransaction
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireCreditCardTransaction
	 RETURN 98
    END
FETCH CreditCardTransaction_cursor
INTO  @xactionId

END
CLOSE CreditCardTransaction_cursor
DEALLOCATE CURSOR CreditCardTransaction_cursor
SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expireCreditCardTransaction TO web
go
IF OBJECT_ID('dbo.wsp_expireCreditCardTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireCreditCardTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireCreditCardTransaction >>>'
go

