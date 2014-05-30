IF OBJECT_ID('dbo.wsp_getPendingCCTransactions') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingCCTransactions
    IF OBJECT_ID('dbo.wsp_getPendingCCTransactions') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingCCTransactions >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingCCTransactions >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         May 30 2005
**   Description:  return list on transactions to be settled
**
** REVISION(S):
**   Author:       Mike Stairs
**   Date:         July 27, 2005
**   Description:  Ignore error rows in response table
**
**   Author:       Andy Tran
**   Date:         February, 2008
**   Description:  Added encodedCardId
**
**   Author:       Andy Tran
**   Date:         June 23, 2008
**   Description:  Added renewalFlag
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getPendingCCTransactions

AS
BEGIN
  DECLARE @rowcount             INT,
          @error                INT,
          @return       	INT,
          @batchId 		INT,
          @dateGMT              DATETIME,
          @xactionId            INT

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
BEGIN
   RETURN @return
END
  
EXEC @return = dbo.wsp_BatchId @batchId OUTPUT
	
IF @return != 0
BEGIN
   RETURN @return
END

IF object_id('#CCTrans') is not null
  BEGIN
    DROP TABLE #CCTrans
  END
  
SELECT xactionId
INTO #CCTrans 
FROM CreditCardTransaction
WHERE CCTranStatusId=1  -- 1 MEANS 'NEW/PENDING'

DECLARE CUR_CCTrans CURSOR FOR
SELECT xactionId
FROM #CCTrans FOR READ ONLY
  
OPEN CUR_CCTrans
  
IF (@@error != 0)
BEGIN
    DEALLOCATE CURSOR CUR_CCTrans
    RETURN 99
END

FETCH CUR_CCTrans INTO @xactionId
  
WHILE (@@sqlstatus != 2)
BEGIN
  IF (@@sqlstatus = 1)
  BEGIN
      CLOSE CUR_CCTrans
      DEALLOCATE CURSOR CUR_CCTrans
      RETURN 99
  END

  BEGIN TRAN TRAN_getPendingCCTransactions

  UPDATE CreditCardTransaction 
     SET batchId = @batchId,
         dateExtracted = @dateGMT,
         CCTranStatusId = 3 
  WHERE xactionId = @xactionId

  IF @@error != 0 
  BEGIN
    ROLLBACK TRAN TRAN_getPendingCCTransactions
    CLOSE CUR_CCTrans
    DEALLOCATE CURSOR CUR_CCTrans
    RETURN 99
  END

  COMMIT TRAN TRAN_getPendingCCTransactions

  FETCH CUR_CCTrans INTO @xactionId

END
  
CLOSE CUR_CCTrans
DEALLOCATE CURSOR CUR_CCTrans

SELECT c.xactionId,
       userId,
       merchantId,
       actionCode,
       p.cardType,
       p.cardNumber,
       p.cardExpiryMonth,
       p.cardExpiryYear,
       p.amount,
       p.currencyCode,
       p.cardHolderName,
       p.userStreet,
       p.userCity,
       p.userState,
       p.userCountryCode,
       p.userPostalCode,
       r.responseCode,
       r.responseDate,
       r.approvalCode,
       r.avsResponseCode,
       p.cardIssueNumber,
       p.cardStartMonth,
       p.cardStartYear,
       p.encodedCardId,
       c.renewalFlag
FROM CreditCardTransaction c,PaymentechRequest p, PaymentechResponse r WHERE c.xactionId = p.xactionId AND c.xactionId = r.xactionId AND CCTranStatusId = 3  AND r.errorMessage IS NULL -- and batchId = @batchId
RETURN 0
END
go
EXEC sp_procxmode 'dbo.wsp_getPendingCCTransactions','unchained'
go
IF OBJECT_ID('dbo.wsp_getPendingCCTransactions') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingCCTransactions >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingCCTransactions >>>'
go
GRANT EXECUTE ON dbo.wsp_getPendingCCTransactions TO web
go

