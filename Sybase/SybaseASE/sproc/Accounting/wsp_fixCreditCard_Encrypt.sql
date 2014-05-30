IF OBJECT_ID('dbo.wsp_fixCreditCard_Encrypt') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_fixCreditCard_Encrypt
    IF OBJECT_ID('dbo.wsp_fixCreditCard_Encrypt') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_fixCreditCard_Encrypt >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_fixCreditCard_Encrypt >>>'
END
go
CREATE PROCEDURE dbo.wsp_fixCreditCard_Encrypt
AS
BEGIN

SELECT GETDATE()

DECLARE
    @creditCardId   int         ,
    @cardNum        varchar(64) ,
    @encodedCardNum varchar(64) ,
    @partialCardNum char(8)     ,
    @realCardTypeId smallint   

DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @rowCountUpdated     int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT


DECLARE CUR_fixCreditCard_Encrypt CURSOR FOR
SELECT  
    creditCardId   ,
    cardNum        ,
    encodedCardNum ,
    partialCardNum ,
    realCardTypeId 
FROM  tempdb..CreditCardBuffer  
FOR READ ONLY

OPEN CUR_fixCreditCard_Encrypt
FETCH CUR_fixCreditCard_Encrypt INTO 
    @creditCardId   ,
    @cardNum        ,
    @encodedCardNum ,
    @partialCardNum ,
    @realCardTypeId 

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_fixCreditCard_Encrypt
       DEALLOCATE CURSOR CUR_fixCreditCard_Encrypt
       SELECT @msgReturn = "error: there is something wrong with CUR_fixCreditCard_Encrypt"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_fixCreditCard_Encrypt

       UPDATE CreditCard
          SET    encodedCardNum = @encodedCardNum,
                 partialCardNum = @partialCardNum,
                 realCardTypeId = @realCardTypeId
                 --dateModified   = @dateModified
          WHERE  creditCardId = @creditCardId and cardNum = @cardNum

       SELECT @errorReturn = @@error, @rowCountUpdated = @@rowcount
 
       IF @errorReturn = 0
       BEGIN
          COMMIT TRAN TRAN_fixCreditCard_Encrypt
          
          IF @rowCountUpdated = 1
          BEGIN
              SELECT @rowCountEffected = @rowCountEffected + 1
          END
          ELSE BEGIN
              SELECT @msgReturn = "Error: 0 row updated WHERE creditCardId =" + convert(varchar(20),@creditCardId)
              PRINT @msgReturn 
          END
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE CreditCard WHERE creditCardId =" + convert(varchar(20),@creditCardId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_fixCreditCard_Encrypt
       END          
    END

    IF @rowCountEffected = 100000
    BEGIN
       SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
       PRINT @msgReturn
       SELECT GETDATE()
    END

    IF @rowCountEffected = 500000
    BEGIN
       SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
       PRINT @msgReturn
       SELECT GETDATE()
    END 

    IF @rowCountEffected = 1000000
    BEGIN
       SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
       PRINT @msgReturn
       SELECT GETDATE()
    END

    FETCH CUR_fixCreditCard_Encrypt INTO
       @creditCardId   ,
       @cardNum        ,
       @encodedCardNum ,
       @partialCardNum ,
       @realCardTypeId

END

CLOSE CUR_fixCreditCard_Encrypt
DEALLOCATE CURSOR CUR_fixCreditCard_Encrypt
SELECT @msgReturn = "WELL DONE with CUR_fixCreditCard_Encrypt"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE()

END

go
IF OBJECT_ID('dbo.wsp_fixCreditCard_Encrypt') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_fixCreditCard_Encrypt >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_fixCreditCard_Encrypt >>>'
go
EXEC sp_procxmode 'dbo.wsp_fixCreditCard_Encrypt','unchained'
go

