IF OBJECT_ID('dbo.wsp_expirePurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expirePurchase
    IF OBJECT_ID('dbo.wsp_expirePurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expirePurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expirePurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Mar 1 2006
**   Description: This proc expires old Purchase transaction records.
**
******************************************************************************/

CREATE PROCEDURE wsp_expirePurchase
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
INTO #DeletePurchase
FROM Purchase
WHERE  
dateCreated < @cutoffDate 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE Purchase_cursor CURSOR FOR
SELECT xactionId 
FROM #DeletePurchase
FOR READ ONLY

OPEN  Purchase_cursor

FETCH Purchase_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE Purchase_cursor
    RETURN 89
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expirePurchase

    DELETE FROM Purchase WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expirePurchase
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expirePurchase
	 RETURN 89
    END

FETCH Purchase_cursor
INTO  @xactionId

END

CLOSE Purchase_cursor
DEALLOCATE CURSOR Purchase_cursor

SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expirePurchase TO web
go
IF OBJECT_ID('dbo.wsp_expirePurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expirePurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expirePurchase >>>'
go

