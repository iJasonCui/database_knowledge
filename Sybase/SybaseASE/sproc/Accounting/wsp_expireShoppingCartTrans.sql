IF OBJECT_ID('dbo.wsp_expireShoppingCartTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireShoppingCartTrans
    IF OBJECT_ID('dbo.wsp_expireShoppingCartTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireShoppingCartTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireShoppingCartTrans >>>'
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

CREATE PROCEDURE wsp_expireShoppingCartTrans
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
INTO #DeleteShoppingCartTrans
FROM ShoppingCartTransaction
WHERE  
dateCreated < @cutoffDate 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE ShoppingCartTrans_cursor CURSOR FOR
SELECT xactionId 
FROM #DeleteShoppingCartTrans

OPEN  ShoppingCartTrans_cursor

FETCH ShoppingCartTrans_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE ShoppingCartTrans_cursor
    DEALLOCATE CURSOR ShoppingCartTrans_cursor
    RETURN 92
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireShoppingCartTrans

    DELETE FROM ShoppingCartTransaction WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireShoppingCartTrans
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireShoppingCartTrans
	 RETURN 92
    END
FETCH ShoppingCartTrans_cursor
INTO  @xactionId

END
CLOSE ShoppingCartTrans_cursor
DEALLOCATE CURSOR ShoppingCartTrans_cursor
SELECT @rowsModified
END

go
GRANT EXECUTE ON dbo.wsp_expireShoppingCartTrans TO web
go
IF OBJECT_ID('dbo.wsp_expireShoppingCartTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireShoppingCartTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireShoppingCartTrans >>>'
go

