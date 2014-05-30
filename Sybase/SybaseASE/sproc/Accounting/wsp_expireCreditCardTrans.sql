IF OBJECT_ID('dbo.wsp_expireCreditCardTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireCreditCardTrans
    IF OBJECT_ID('dbo.wsp_expireCreditCardTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireCreditCardTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireCreditCardTrans >>>'
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

CREATE PROCEDURE wsp_expireCreditCardTrans
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

OPEN  CreditCardTransaction_cursor

FETCH CreditCardTransaction_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditCardTransaction_cursor
    DEALLOCATE CURSOR CreditCardTransaction_cursor
    RETURN 97
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireCreditCardTrans

    DELETE FROM CreditCardTransaction WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireCreditCardTrans
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireCreditCardTrans
	 RETURN 97
    END
FETCH CreditCardTransaction_cursor
INTO  @xactionId

END
CLOSE CreditCardTransaction_cursor
DEALLOCATE CURSOR CreditCardTransaction_cursor
SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expireCreditCardTrans TO web
go
IF OBJECT_ID('dbo.wsp_expireCreditCardTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireCreditCardTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireCreditCardTrans >>>'
go

