IF OBJECT_ID('dbo.wsp_expireSubNonfinancialTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireSubNonfinancialTrans
    IF OBJECT_ID('dbo.wsp_expireSubNonfinancialTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireSubNonfinancialTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireSubNonfinancialTrans >>>'
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

CREATE PROCEDURE wsp_expireSubNonfinancialTrans
@cutoffDate     		DATETIME 
,@rowCount                      INT
,@rowsModified                  INT OUTPUT
AS
DECLARE 
@xactionId			INT

BEGIN
SELECT @rowsModified = 0

SET ROWCOUNT @rowCount
SELECT nonFinancialXActionId 
INTO #DeleteSubNonfinancialTrans
FROM SubscriptionNonfinancialTrans
WHERE  
dateCreated < @cutoffDate 
SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE DeleteSubNonfinTrans_cursor CURSOR FOR
SELECT nonFinancialXActionId 
FROM #DeleteSubNonfinancialTrans

OPEN  DeleteSubNonfinTrans_cursor

FETCH DeleteSubNonfinTrans_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE DeleteSubNonfinTrans_cursor
    DEALLOCATE CURSOR DeleteSubNonfinTrans_cursor
    RETURN 95
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireSubNonfinTrans

    DELETE FROM SubscriptionNonfinancialTrans WHERE nonFinancialXActionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireSubNonfinTrans
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireSubNonfinTrans
	 RETURN 95
    END
FETCH DeleteSubNonfinTrans_cursor
INTO  @xactionId

END
CLOSE DeleteSubNonfinTrans_cursor
DEALLOCATE CURSOR DeleteSubNonfinTrans_cursor
SELECT @rowsModified
END 

go
GRANT EXECUTE ON dbo.wsp_expireSubNonfinancialTrans TO web
go
IF OBJECT_ID('dbo.wsp_expireSubNonfinancialTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireSubNonfinancialTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireSubNonfinancialTrans >>>'
go

