IF OBJECT_ID('dbo.wsp_expireSettlementResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireSettlementResponse
    IF OBJECT_ID('dbo.wsp_expireSettlementResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireSettlementResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireSettlementResponse >>>'
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

CREATE PROCEDURE wsp_expireSettlementResponse
@cutoffDate     		DATETIME 
,@rowCount                      INT
,@rowsModified                  INT OUTPUT
AS
BEGIN

DECLARE
@dateNow                        DATETIME
,@return                        INT
,@xactionId                     INT


SELECT @rowsModified = 0
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT

IF @return != 0
BEGIN
   RETURN @return
END

IF @cutoffDate > dateadd(mm, -18, @dateNow) 
BEGIN
   print "Msg: breaking retention rule, we just delete unused CC info for 18 month, input cutoffDate=%1!", @cutoffDate     
   RETURN 99
END      

SET ROWCOUNT @rowCount
SELECT xactionId 
INTO #DeleteSettlementResponse
FROM SettlementResponse
WHERE  
  dateCreated < @cutoffDate 
  AND dateCreated >= dateadd(dd,-2,@cutoffDate)

SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE SettlementResponse_cursor CURSOR FOR
SELECT xactionId 
FROM #DeleteSettlementResponse
FOR READ ONLY

OPEN  SettlementResponse_cursor

FETCH SettlementResponse_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE SettlementResponse_cursor
    DEALLOCATE CURSOR SettlementResponse_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireSettlementResponse

    DELETE FROM SettlementResponse WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireSettlementResponse
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireSettlementResponse
	 RETURN 98
    END
FETCH SettlementResponse_cursor
INTO  @xactionId

END
CLOSE SettlementResponse_cursor
DEALLOCATE CURSOR SettlementResponse_cursor
SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expireSettlementResponse TO web
go
IF OBJECT_ID('dbo.wsp_expireSettlementResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireSettlementResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireSettlementResponse >>>'
go

