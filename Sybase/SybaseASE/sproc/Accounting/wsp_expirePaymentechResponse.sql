IF OBJECT_ID('dbo.wsp_expirePaymentechResponse') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expirePaymentechResponse
    IF OBJECT_ID('dbo.wsp_expirePaymentechResponse') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expirePaymentechResponse >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expirePaymentechResponse >>>'
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

CREATE PROCEDURE wsp_expirePaymentechResponse
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
INTO #DeletePaymentechResponse
FROM PaymentechResponse
WHERE  
  dateCreated < @cutoffDate 
  AND dateCreated  >= dateadd(dd,-2,@cutoffDate) 

SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE PaymentechResponse_cursor CURSOR FOR
SELECT xactionId 
FROM #DeletePaymentechResponse
FOR READ ONLY

OPEN  PaymentechResponse_cursor

FETCH PaymentechResponse_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE PaymentechResponse_cursor
    DEALLOCATE CURSOR PaymentechResponse_cursor
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expirePaymentechResponse

    DELETE FROM PaymentechResponse WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expirePaymentechResponse
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expirePaymentechResponse
         CLOSE PaymentechResponse_cursor
         DEALLOCATE CURSOR PaymentechResponse_cursor
	 RETURN 98
    END
FETCH PaymentechResponse_cursor
INTO  @xactionId

END
CLOSE PaymentechResponse_cursor
DEALLOCATE CURSOR PaymentechResponse_cursor
SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expirePaymentechResponse TO web
go
IF OBJECT_ID('dbo.wsp_expirePaymentechResponse') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expirePaymentechResponse >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expirePaymentechResponse >>>'
go

