IF OBJECT_ID('dbo.fix_cardTypeId2010Aug') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.fix_cardTypeId2010Aug
    IF OBJECT_ID('dbo.fix_cardTypeId2010Aug') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.fix_cardTypeId2010Aug >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.fix_cardTypeId2010Aug >>>'
END
go
create proc dbo.fix_cardTypeId2010Aug
AS 
BEGIN

  /*

drop table mda_db..PurchaseCard2010Aug

SELECT pu.creditCardId, pu.currencyId, max(xactionId) AS xactionId
INTO   mda_db..PurchaseCard2010Aug
FROM   Accounting..Purchase pu 
WHERE  pu.xactionTypeId in (6,31,32) 
  AND  pu.dateCreated >= "aug 1 2010"
  AND  pu.dateCreated <  "Sep 2 2010"
GROUP BY pu.creditCardId, pu.currencyId

--=====================================
-- where pu.creditCardId <0
--=====================================
drop table mda_db..PurchaseCard2010Aug0
select * into mda_db..PurchaseCard2010Aug0 from mda_db..PurchaseCard2010Aug pu where pu.creditCardId <0
select * from mda_db..PurchaseCard2010Aug0

delete from mda_db..PurchaseCard2010Aug where creditCardId <0

--=======================================================================
--create unique index 
--====================================

CREATE UNIQUE NONCLUSTERED INDEX idx_cardId     ON dbo.PurchaseCard2010Aug(creditCardId)

CREATE UNIQUE NONCLUSTERED INDEX idx_xactionId  ON dbo.PurchaseCard2010Aug(xactionId)

--=====================================================


-- join with CreditCard cc,Purchase pu, PaymentechRequest rq,PaymentechResponse rs

drop table mda_db..creditCard2010Aug

SELECT pu.creditCardId,pu.currencyId,pu.xactionId,
       rq.cardType as cardType_req,
       rs.cardType as cardType_res,
       cc.realCardTypeId, cc.cardTypeId
INTO   mda_db..creditCard2010Aug
FROM   CreditCard cc, mda_db..PurchaseCard2010Aug pu, PaymentechRequest rq,PaymentechResponse rs
WHERE  cc.creditCardId = pu.creditCardId 
  AND  pu.xactionId = rq.xactionId
  AND  pu.xactionId = rs.xactionId
  AND  rq.xactionId = rs.xactionId


--=======================================
select *
from mda_db..creditCard2010Aug
where  cardType_req != cardType_res 

drop table mda_db..creditCard2010AugFix

SELECT 
     CASE
          WHEN cardType_req = 'VI' and currencyId=0 THEN 1
          WHEN cardType_req = 'MC' and currencyId=0 THEN 2
          WHEN cardType_req = 'AX' and currencyId=0 THEN 3
          WHEN cardType_req = 'JC' and currencyId=0 THEN 4
          WHEN cardType_req = 'DC' and currencyId=0 THEN 5
          WHEN cardType_req = 'DI' and currencyId=0 THEN 25
          WHEN cardType_req = 'VI' and currencyId=2 THEN 12
          WHEN cardType_req = 'MC' and currencyId=2 THEN 13
          WHEN cardType_req = 'AX' and currencyId=2 THEN 14
          WHEN cardType_req = 'VI' and currencyId=3 THEN 19
          WHEN cardType_req = 'MC' and currencyId=3 THEN 20
          WHEN cardType_req = 'AX' and currencyId=3 THEN 21                    
          WHEN cardType_req = 'VI' and currencyId=4 THEN 26
          WHEN cardType_req = 'MC' and currencyId=4 THEN 27
          WHEN cardType_req = 'AX' and currencyId=4 THEN 28       
     END
     AS realCardTypeIdFix,
     realCardTypeId,
     creditCardId
INTO mda_db..creditCard2010AugFix
FROM mda_db..creditCard2010Aug 


select *
into mda_db..creditCard2010AugFinal 
from mda_db..creditCard2010AugFix a
where a.realCardTypeIdFix != a.realCardTypeId

  */

  DECLARE @creditCardId INT 
  DECLARE @realCardTypeId SMALLINT
  DECLARE @realCardTypeIdFix SMALLINT
  
  DECLARE @rowAffected1 INT,@rowAffected2 INT,@rowAffected3 INT,@rowAffected4 INT
  DECLARE @msgReturn varchar(100)

  DECLARE CUR_creditCard CURSOR FOR
  SELECT  creditCardId,realCardTypeId,realCardTypeIdFix
  FROM    mda_db..creditCard2010AugFinal 
  FOR READ ONLY
  
  OPEN CUR_creditCard

  FETCH CUR_creditCard
  INTO @creditCardId,@realCardTypeId,@realCardTypeIdFix

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
    
    UPDATE CreditCard
    SET    realCardTypeId = @realCardTypeIdFix
    WHERE  creditCardId = @creditCardId and realCardTypeId = @realCardTypeId 
         
    SELECT @rowAffected1    =   @rowAffected1   + @@rowcount 
 
    FETCH CUR_creditCard INTO @creditCardId,@realCardTypeId,@realCardTypeIdFix
  
  END 
  CLOSE CUR_creditCard
  DEALLOCATE CURSOR CUR_creditCard
  
  SELECT @msgReturn = "WELL DONE with CUR_creditCard"
  PRINT @msgReturn
  SELECT @msgReturn = CONVERT(VARCHAR(20),@rowAffected1) + "  rows HAS BEEN UPDATED" 
  PRINT @msgReturn
  
END

go
EXEC sp_procxmode 'dbo.fix_cardTypeId2010Aug','unchained'
go
IF OBJECT_ID('dbo.fix_cardTypeId2010Aug') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.fix_cardTypeId2010Aug >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.fix_cardTypeId2010Aug >>>'
go

