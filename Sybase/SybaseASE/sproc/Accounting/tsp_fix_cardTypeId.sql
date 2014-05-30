USE Accounting
go
IF OBJECT_ID('dbo.tsp_fix_cardTypeId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_fix_cardTypeId
    IF OBJECT_ID('dbo.tsp_fix_cardTypeId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_fix_cardTypeId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_fix_cardTypeId >>>'
END
go
create proc dbo.tsp_fix_cardTypeId
AS 
BEGIN
  DECLARE @creditCardId INT,@currencyId SMALLINT,@cardType CHAR(2),@realCardTypeId SMALLINT,@orig_realCardTypeId SMALLINT
  DECLARE @rowAffected1 INT,@rowAffected2 INT,@rowAffected3 INT,@rowAffected4 INT
  DECLARE @msgReturn varchar(100)

  /*

  SELECT  cc.creditCardId,pu.currencyId,rq.cardType,cc.realCardTypeId,pu.xactionId
  INTO   tempdb..creditCard
  FROM   CreditCard cc,Purchase pu, PaymentechRequest rq,PaymentechResponse rs
  WHERE  cc.creditCardId = pu.creditCardId and pu.xactionId=rq.xactionId
  AND    rq.xactionId = rs.xactionId
  AND    pu.xactionId in 
  ( select max(xactionId) 
    from Purchase pu 
    where pu.xactionTypeId in (6,31,32)
    group by creditCardId )

  */

  DECLARE CUR_creditCard CURSOR FOR
  SELECT  creditCardId,currencyId,cardType,realCardTypeId
  FROM    tempdb..creditCard
  --where   xactionId in ( select max(xactionId) from tempdb..creditCard group by creditCardId)
  FOR READ ONLY
  
  OPEN CUR_creditCard

  FETCH CUR_creditCard
  INTO @creditCardId, @currencyId, @cardType, @orig_realCardTypeId

  SELECT @rowAffected1=0
  SELECT @rowAffected2=0
  SELECT @rowAffected3=0
  SELECT @rowAffected4=0

  WHILE (@@sqlstatus != 2)
  BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_creditCard
       DEALLOCATE CURSOR CUR_creditCard
       SELECT @msgReturn = "error: there is something wrong with CUR_creditCard"
       PRINT @msgReturn
       
       RETURN 99
    END
    
    IF (@currencyId=0)  --US
    BEGIN
      SELECT @realCardTypeId  = 
        CASE
          WHEN @cardType = 'VI' THEN 1
          WHEN @cardType = 'MC' THEN 2
          WHEN @cardType = 'AX' THEN 3
          WHEN @cardType = 'JC' THEN 4
          WHEN @cardType = 'DC' THEN 5
          WHEN @cardType = 'DI' THEN 25
        END
        select @rowAffected1 = @rowAffected1 + 1 
    END

    IF (@currencyId=2)  --UK
    BEGIN
      SELECT @realCardTypeId  = 
        CASE
          WHEN @cardType = 'VI' THEN 12
          WHEN @cardType = 'MC' THEN 13
          WHEN @cardType = 'AX' THEN 14
        END
        select @rowAffected2 = @rowAffected2 + 1 
    END

    IF (@currencyId=3)  --AU
    BEGIN
      SELECT @realCardTypeId  = 
        CASE
          WHEN @cardType = 'VI' THEN 19
          WHEN @cardType = 'MC' THEN 20
          WHEN @cardType = 'AX' THEN 21
        END
        select @rowAffected3 = @rowAffected3 + 1 
    END

    IF (@currencyId=4)  --CA
    BEGIN
      SELECT @realCardTypeId  = 
        CASE
          WHEN @cardType = 'VI' THEN 26
          WHEN @cardType = 'MC' THEN 27
          WHEN @cardType = 'AX' THEN 28
        END
        select @rowAffected4 = @rowAffected4 + 1 
    END
   
    --IF ( @realCardTypeId != @orig_realCardTypeId)
    --BEGIN
      UPDATE CreditCard
      SET    realCardTypeId = @realCardTypeId
      WHERE  creditCardId = @creditCardId
      --insert into tempdb..test
      --select @currencyId currencyId,@cardType cardType ,@realCardTypeId realCardTypeId,@creditCardId creditCardId
    --END 
          
    FETCH CUR_creditCard
    INTO @creditCardId,@currencyId,@cardType,@orig_realCardTypeId
  
  END 
  CLOSE CUR_creditCard
  DEALLOCATE CURSOR CUR_creditCard
  SELECT @msgReturn = "WELL DONE with CUR_creditCard"
  PRINT @msgReturn
  SELECT @msgReturn = CONVERT(VARCHAR(20),@rowAffected1) + " US ,  " + CONVERT(VARCHAR(20),@rowAffected2)+ "  UK ,  " + CONVERT(VARCHAR(20),@rowAffected3)+ "  AU , " + CONVERT(VARCHAR(20),@rowAffected4)+ "  CA HAS BEEN UPDATED"
  PRINT @msgReturn
  
END
go
EXEC sp_procxmode 'dbo.tsp_fix_cardTypeId', 'unchained'
go
IF OBJECT_ID('dbo.tsp_fix_cardTypeId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_fix_cardTypeId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_fix_cardTypeId >>>'
go

