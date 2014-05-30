IF OBJECT_ID('dbo.wsp_newCCTran') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newCCTran
    IF OBJECT_ID('dbo.wsp_newCCTran') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newCCTran >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newCCTran >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason Cui
**   Date:    May 16 2005
**   Description:  Insert a row to CreditCardTransaction to mark a credit card transaction which has been authorized
**
** REVISION(S):
**   Author:  Jeff Yang
**   Date:  June 7 2008
**   Description: Insert a row to SettlementQueue first if exists row in AccountFlag for Admin to review
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newCCTran
  @xactionId  numeric(12,0)

AS
  DECLARE @rowcount INT
  DECLARE @error    INT
  DECLARE @return	INT
  DECLARE @dateGMT	DATETIME
  DECLARE @productId INT

  EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
  IF @return != 0
  BEGIN
     RETURN @return
  END
  
  BEGIN TRAN csp_newCCTran

 
  DECLARE @userId   numeric(12,0) 
  select @userId = userId from PaymentechRequest where xactionId=@xactionId 

  IF @userId is not null and EXISTS 
                       (SELECT 1 FROM AccountFlag flag, UserAccount ua 
                                 WHERE flag.userId = @userId 
                                   and flag.userId=ua.userId 
                                   and reviewed <>'Y' 
                                   and ua.accountType="S" 
                                   and ua.dateCreated > dateAdd(dd, -550, getDate())) 
  BEGIN 

     SELECT @productId = productId 
     FROM UserAccount u, BillingLocation bl 
     WHERE u.userId=@userId AND u.billingLocationId=bl.billingLocationId

     INSERT SettlementQueue 
           (xactionId, dateCreated, status, productId )
     VALUES
           (@xactionId, @dateGMT, 0, @productId) -- 0 MEANS "PENDING for admin approval"
     
     IF @@error = 0

     BEGIN
        INSERT CreditCardTransaction
              (xactionId, dateCreated, CCTranStatusId )
        VALUES
              (@xactionId, @dateGMT, 6) -- 6 MEANS "PEDNING for admin approval"
     END 

  END 

  ELSE 

  BEGIN 
     INSERT CreditCardTransaction
           (xactionId,
            dateCreated,
            CCTranStatusId )
     VALUES
           (@xactionId,
            @dateGMT,
            1) -- 1 MEANS "NEW/PENDING"
  END 

  SELECT @error = @@error, @rowcount = @@rowcount

  IF @error = 0 
  BEGIN
    COMMIT TRAN csp_newCCTran
  END 
  ELSE BEGIN
    ROLLBACK TRAN csp_newCCTran
  END
  
  SELECT @error AS RESULT,@rowcount AS ROWCNT,@xactionId AS PRIMKEY

go
EXEC sp_procxmode 'dbo.wsp_newCCTran','unchained'
go
IF OBJECT_ID('dbo.wsp_newCCTran') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newCCTran >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newCCTran >>>'
go
GRANT EXECUTE ON dbo.wsp_newCCTran TO web
go

