USE Accounting
go
IF OBJECT_ID('dbo.tsp_fix_realcardTypeId_8') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_fix_realcardTypeId_8
    IF OBJECT_ID('dbo.tsp_fix_realcardTypeId_8') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_fix_realcardTypeId_8 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_fix_realcardTypeId_8 >>>'
END
go
create proc dbo.tsp_fix_realcardTypeId_8
AS 
BEGIN
  DECLARE @creditCardId INT,@realCardTypeId SMALLINT,@cardTypeId SMALLINT
  DECLARE @rowAffected1 INT,@rowAffected2 INT,@rowAffected3 INT,@rowAffected4 INT
  DECLARE @msgReturn varchar(100)

  /*

  SELECT creditCardId,cardTypeId,realCardTypeId,status
  INTO   tempdb..tmp_creditCard
  FROM   CreditCard

  */

  DECLARE CUR_creditCard CURSOR FOR
  SELECT  creditCardId,cardTypeId,realCardTypeId
  FROM    tempdb..tmp_creditCard
  FOR READ ONLY
  
  OPEN CUR_creditCard

  FETCH CUR_creditCard
  INTO @creditCardId, @cardTypeId, @realCardTypeId

  SELECT @rowAffected1=0
  SELECT @rowAffected2=0
  SELECT @rowAffected3=0

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
    
    IF (@realCardTypeId = 8)   -- 1
    BEGIN
      SELECT @realCardTypeId  = 25 
      UPDATE CreditCard
      SET    realCardTypeId = @realCardTypeId
      WHERE  creditCardId = @creditCardId

      select @rowAffected1=@rowAffected1+@@rowcount
      IF (@rowAffected1 !=0 and @rowAffected1 % 10000 = 0)
         print "%1! first kind of records have been processed",@rowAffected1
    END

    IF (@realCardTypeId in (1, 2, 3) )  -- 2
    BEGIN
      IF (@cardTypeId IN (12,13,14)) 
      BEGIN
        SELECT @realCardTypeId  = 
        CASE
          WHEN @realCardTypeId = 1 THEN 12
          WHEN @realCardTypeId = 2 THEN 13
          WHEN @realCardTypeId = 3 THEN 14
        END
      END

      IF (@cardTypeId IN (19,20,21))
      BEGIN
        SELECT @realCardTypeId  = 
        CASE
          WHEN @realCardTypeId = 1 THEN 19
          WHEN @realCardTypeId = 2 THEN 20
          WHEN @realCardTypeId = 3 THEN 21
        END
      END

      IF (@cardTypeId IN (26,27,28))
      BEGIN
        SELECT @realCardTypeId  = 
        CASE
          WHEN @realCardTypeId = 1 THEN 26
          WHEN @realCardTypeId = 2 THEN 27
          WHEN @realCardTypeId = 3 THEN 28
        END
      END
   
      UPDATE CreditCard
      SET    realCardTypeId = @realCardTypeId
      WHERE  creditCardId = @creditCardId

      select @rowAffected2=@rowAffected2+@@rowcount
      IF (@rowAffected2 !=0 and @rowAffected2 % 10000 = 0)
         print "%1! second kind of records have been processed",@rowAffected2
    END

    IF ( @realCardTypeId not in (1, 2, 3, 4, 5, 25, 12, 13, 14, 19, 20, 21, 26, 27, 28) and @realCardTypeId IS NOT NULL )
    BEGIN      
      UPDATE CreditCard
      SET status = 'I', dateModified = getdate()
      WHERE creditCardId = @creditCardId

      select @rowAffected3=@rowAffected3+@@rowcount
      IF (@rowAffected3 !=0 and @rowAffected3 % 10000 = 0)
         print "%1! third  kind of records have been processed",@rowAffected3
    END


    FETCH CUR_creditCard
    INTO @creditCardId,@cardTypeId,@realCardTypeId
  
  END 
  CLOSE CUR_creditCard
  DEALLOCATE CURSOR CUR_creditCard
  SELECT @msgReturn = "WELL DONE with CUR_creditCard"
  PRINT @msgReturn
  SELECT @msgReturn = CONVERT(VARCHAR(20),@rowAffected1) + ",   " + CONVERT(VARCHAR(20),@rowAffected2) + ",   " + CONVERT(VARCHAR(20),@rowAffected3) + " HAS BEEN UPDATED"
  PRINT @msgReturn
  
END
go
EXEC sp_procxmode 'dbo.tsp_fix_realcardTypeId_8', 'unchained'
go
IF OBJECT_ID('dbo.tsp_fix_realcardTypeId_8') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_fix_realcardTypeId_8 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_fix_realcardTypeId_8 >>>'
go

