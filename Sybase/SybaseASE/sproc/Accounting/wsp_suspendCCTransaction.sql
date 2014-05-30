IF OBJECT_ID('dbo.wsp_suspendCCTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_suspendCCTransaction
    IF OBJECT_ID('dbo.wsp_suspendCCTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_suspendCCTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_suspendCCTransaction >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Hunter Qian 
**   Date:        June 5 2008 
**   Description: suspend cc transactions pending for settlement to Settlement queue
**
** REVISION(S):
**   Author: 
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_suspendCCTransaction
 @userId            NUMERIC(12,0)
AS
BEGIN
  DECLARE
  @return            INT
  ,@dateNow       DATETIME
  ,@xactionId     INT
  ,@productId     INT
 

  IF @userId is not null and EXISTS
                       (SELECT 1 FROM UserAccount 
                                 WHERE userId = @userId
                                   and accountType="S"
                                   and dateCreated > dateAdd(dd, -550, getDate()))
BEGIN


  SELECT @productId = productId
  FROM UserAccount u, BillingLocation bl
  WHERE u.userId=@userId AND u.billingLocationId=bl.billingLocationId
 
  EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
  IF @return != 0
    BEGIN
        RETURN @return
    END

  IF object_id("#SuspectTrans") is not null
  BEGIN
    DROP TABLE #SuspectTrans
  END
  
  SELECT c.xactionId, c.dateCreated
  INTO #SuspectTrans 
  FROM CreditCardTransaction c,Purchase p 
  WHERE c.xactionId=p.xactionId 
  and p.userId=@userId and c.CCTranStatusId=1
  and c.dateCreated >= dateadd(dd,-2, @dateNow)

  DECLARE CUR_SuspentTrans CURSOR FOR
  SELECT xactionId
  FROM #SuspectTrans FOR READ ONLY   

  OPEN CUR_SuspentTrans

  IF (@@error != 0)
  BEGIN
    DEALLOCATE CURSOR CUR_SuspentTrans
    RETURN 99
  END

  FETCH CUR_SuspentTrans INTO @xactionId

  WHILE (@@sqlstatus != 2)
  BEGIN
    IF (@@sqlstatus = 1)
    BEGIN
      CLOSE CUR_SuspentTrans
      DEALLOCATE CURSOR CUR_SuspentTrans
      RETURN 99
    END

    BEGIN TRAN TRAN_suspendCCTransaction
  
    IF not exists (select 1 from SettlementQueue where xactionId = @xactionId)
    BEGIN
      INSERT SettlementQueue (xactionId, status, dateCreated, productId) values (@xactionId, 0, @dateNow, @productId)

      IF (@@error != 0)
      BEGIN
        ROLLBACK TRAN TRAN_suspendCCTransaction
        CLOSE CUR_SuspentTrans
        DEALLOCATE CURSOR CUR_SuspentTrans
        RETURN 99
      END
    END 
    ELSE
    BEGIN
      UPDATE SettlementQueue set status=0 where xactionId = @xactionId
      
      IF (@@error != 0)
      BEGIN
        ROLLBACK TRAN TRAN_suspendCCTransaction
        CLOSE CUR_SuspentTrans
        DEALLOCATE CURSOR CUR_SuspentTrans
        RETURN 99
      END
    END
  
    UPDATE CreditCardTransaction 
    SET  CCTranStatusId =6 
    WHERE xactionId=@xactionId
  
    IF (@@error != 0)
    BEGIN
      ROLLBACK TRANTRAN_suspendCCTransaction
      CLOSE CUR_SuspentTrans
      DEALLOCATE CURSOR CUR_SuspentTrans      
      RETURN 99
    END

    COMMIT TRAN TRAN_suspendCCTransaction

    FETCH CUR_SuspentTrans INTO @xactionId

  END -- end of while 



  END
  RETURN 0

END

go

EXEC sp_procxmode 'dbo.wsp_suspendCCTransaction','unchained'
go
IF OBJECT_ID('dbo.wsp_suspendCCTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_suspendCCTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_suspendCCTransaction >>>'
go

GRANT EXECUTE ON dbo.wsp_suspendCCTransaction TO web
go
