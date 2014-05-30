IF OBJECT_ID('dbo.wsp_getPendingCCTrans') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getPendingCCTrans
    IF OBJECT_ID('dbo.wsp_getPendingCCTrans') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getPendingCCTrans >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getPendingCCTrans >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Feb 24 2011
**   Description:  Return list of pending credit card transactions to be settled.
**                 This procedure returns only the xactionId of the transactions.
**                 It does not join with the request/response tables which are
**                 different for different payment processor.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getPendingCCTrans

AS
BEGIN
  DECLARE @rowcount INT,
          @error INT,
          @return INT,
          @batchId INT,
          @dateGMT DATETIME,
          @xactionId INT

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

  BEGIN TRAN TRAN_getPendingCCTrans

  UPDATE CreditCardTransaction 
     SET batchId = @batchId,
         dateExtracted = @dateGMT,
         CCTranStatusId = 3 
  WHERE xactionId = @xactionId

  IF @@error != 0 
  BEGIN
    ROLLBACK TRAN TRAN_getPendingCCTrans
    CLOSE CUR_CCTrans
    DEALLOCATE CURSOR CUR_CCTrans
    RETURN 99
  END

  COMMIT TRAN TRAN_getPendingCCTrans

  FETCH CUR_CCTrans INTO @xactionId

END
  
CLOSE CUR_CCTrans
DEALLOCATE CURSOR CUR_CCTrans

SELECT xactionId,
       renewalFlag
FROM CreditCardTransaction
WHERE CCTranStatusId = 3
RETURN 0
END
go
EXEC sp_procxmode 'dbo.wsp_getPendingCCTrans','unchained'
go
IF OBJECT_ID('dbo.wsp_getPendingCCTrans') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getPendingCCTrans >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getPendingCCTrans >>>'
go
GRANT EXECUTE ON dbo.wsp_getPendingCCTrans TO web
go

