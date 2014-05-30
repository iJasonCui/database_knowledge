IF OBJECT_ID('dbo.wsp_expireCreditCardTran') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_expireCreditCardTran
    IF OBJECT_ID('dbo.wsp_expireCreditCardTran') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_expireCreditCardTran >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_expireCreditCardTran >>>'
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

CREATE PROCEDURE wsp_expireCreditCardTran
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
INTO #DeleteCreditCardTransaction
FROM CreditCardTransaction
WHERE  
  dateCreated < @cutoffDate 
  AND dateCreated >= dateadd(dd,-2,@cutoffDate)


SET ROWCOUNT 0

IF @@rowcount = 0 
BEGIN
  SELECT @rowsModified = 0
  RETURN 0
END

DECLARE CreditCardTransaction_CUR CURSOR FOR
SELECT xactionId 
FROM #DeleteCreditCardTransaction
FOR READ ONLY

OPEN  CreditCardTransaction_CUR

FETCH CreditCardTransaction_CUR
INTO  @xactionId

IF (@@sqlstatus = 2)
BEGIN
    CLOSE CreditCardTransaction_CUR
    DEALLOCATE CURSOR CreditCardTransaction_CUR
    RETURN 98
END

WHILE (@@sqlstatus = 0)
BEGIN

  BEGIN TRAN TRAN_expireCreditCardTran

    DELETE FROM CreditCardTransaction WHERE xactionId = @xactionId 

   IF @@error = 0
     BEGIN
	 COMMIT TRAN TRAN_expireCreditCardTran
         SELECT @rowsModified = @rowsModified + 1
     END
   ELSE
     BEGIN
	 ROLLBACK TRAN TRAN_expireCreditCardTran
         CLOSE CreditCardTransaction_CUR
         DEALLOCATE CURSOR CreditCardTransaction_CUR
	 RETURN 98
    END
FETCH CreditCardTransaction_CUR
INTO  @xactionId

END
CLOSE CreditCardTransaction_CUR
DEALLOCATE CURSOR CreditCardTransaction_CUR
SELECT @rowsModified
END
go
GRANT EXECUTE ON dbo.wsp_expireCreditCardTran TO web
go
IF OBJECT_ID('dbo.wsp_expireCreditCardTran') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_expireCreditCardTran >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_expireCreditCardTran >>>'
go

