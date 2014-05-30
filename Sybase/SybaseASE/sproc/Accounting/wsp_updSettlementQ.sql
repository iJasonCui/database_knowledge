IF OBJECT_ID('dbo.wsp_updSettlementQ') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updSettlementQ
    IF OBJECT_ID('dbo.wsp_updSettlementQ') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updSettlementQ >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updSettlementQ >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jeff Yang 
**   Date:    Jnue 7 2008
**   Description:  approve or reject settlement q and insert a row into CreditCardTransaction table. 
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updSettlementQ
  @xactionId  numeric(12,0),
  @status int, 
  @adminUserId int 

AS
  DECLARE @rowcount INT
  DECLARE @error    INT
  DECLARE @return	INT
  DECLARE @dateGMT	DATETIME

  EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
  IF @return != 0
  BEGIN
     RETURN @return
  END
  
  BEGIN TRAN csp_updSettlementQ

  IF @status = 1 or @status = 2 
  BEGIN

       UPDATE SettlementQueue 
       SET status=@status, adminUserId=@adminUserId, dateReviewed=@dateGMT 
       WHERE xactionId=@xactionId
              -- In SettlemtnQueue 
              -- 0 MEANS pending approve 
              -- 1 MEANS approved, in other words: it is for Pending settlement 
              -- 2 MEANS rejected 
     
       IF @@error = 0 
       BEGIN

          UPDATE CreditCardTransaction 
          SET CCTranStatusId = @status 
          WHERE xactionId = @xactionId 
            AND CCTranStatusId = 6
        
                 -- In CreditCardTransaction: 
                 -- 1 MEANS Pending for settlement 
                 -- 2 MEANS void 
       END
  END

  SELECT @error = @@error, @rowcount = @@rowcount

  IF @error = 0 
  BEGIN
    COMMIT TRAN csp_updSettlementQ
  END 
  ELSE BEGIN
    ROLLBACK TRAN csp_updSettlementQ
  END
  
  SELECT @error AS RESULT,@rowcount AS ROWCNT,@xactionId AS PRIMKEY

go
EXEC sp_procxmode 'dbo.wsp_updSettlementQ','unchained'
go
IF OBJECT_ID('dbo.wsp_updSettlementQ') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updSettlementQ >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updSettlementQ >>>'
go
GRANT EXECUTE ON dbo.wsp_updSettlementQ TO web
go

