IF OBJECT_ID('dbo.wsp_expirePaymentechRequest') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expirePaymentechRequest
    IF OBJECT_ID('dbo.wsp_expirePaymentechRequest') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expirePaymentechRequest >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expirePaymentechRequest >>>'
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

CREATE PROCEDURE wsp_expirePaymentechRequest
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
INTO #DeletePaymentechRequest
FROM PaymentechRequest
WHERE  
  dateCreated < @cutoffDate 
  AND dateCreated >= dateadd(dd,-2,@cutoffDate)

SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE PaymentechRequest_cursor CURSOR FOR
SELECT xactionId 
FROM #DeletePaymentechRequest
FOR READ ONLY

OPEN  PaymentechRequest_cursor

FETCH PaymentechRequest_cursor
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE PaymentechRequest_cursor
    RETURN 99
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expirePaymentechRequest

    DELETE FROM PaymentechRequest WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expirePaymentechRequest
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expirePaymentechRequest
         CLOSE PaymentechRequest_cursor
         DEALLOCATE CURSOR PaymentechRequest_cursor
	 RETURN 99
    END

FETCH PaymentechRequest_cursor
INTO  @xactionId

END

CLOSE PaymentechRequest_cursor
DEALLOCATE CURSOR PaymentechRequest_cursor

SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expirePaymentechRequest TO web
go
IF OBJECT_ID('dbo.wsp_expirePaymentechRequest') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expirePaymentechRequest >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expirePaymentechRequest >>>'
go

