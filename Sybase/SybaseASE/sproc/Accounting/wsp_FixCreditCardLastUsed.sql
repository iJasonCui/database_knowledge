IF OBJECT_ID('dbo.wsp_FixCreditCardLastUsed') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixCreditCardLastUsed
    IF OBJECT_ID('dbo.wsp_FixCreditCardLastUsed') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixCreditCardLastUsed >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixCreditCardLastUsed >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixCreditCardLastUsed
AS
BEGIN

SELECT GETDATE()

DECLARE @creditCardId int      
DECLARE @dateLastUsed datetime 

DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME
DECLARE @dateCutOff          DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

SELECT @dateCutOff = DATEADD(mm, -18, @dateModified)

SELECT GETDATE() 

--SELECT creditCardId, max(dateCreated) as dateLastUsed INTO tempdb..CreditCardLastUsed 
--FROM Accounting..Purchase GROUP BY creditCardId 

DECLARE CUR_FixCreditCardLastUsed CURSOR FOR
SELECT creditCardId , dateLastUsed 
FROM   tempdb..CreditCardLastUsed 
FOR READ ONLY

OPEN CUR_FixCreditCardLastUsed
FETCH CUR_FixCreditCardLastUsed INTO @creditCardId, @dateLastUsed

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixCreditCardLastUsed
       DEALLOCATE CURSOR CUR_FixCreditCardLastUsed
       SELECT @msgReturn = "error: there is something wrong with CUR_FixCreditCardLastUsed"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixCreditCardLastUsed

       IF @dateLastUsed < @dateCutOff
       BEGIN
          UPDATE CreditCard
          SET encodedCardNum ='',
              status = 'I',
              dateLastUsed = @dateLastUsed,
              dateModified = @dateModified
          WHERE creditCardId = @creditCardId AND dateLastUsed IS NULL AND status != 'B'

          SELECT @errorReturn = @@error
       END 
       ELSE BEGIN
          UPDATE CreditCard
          SET    dateLastUsed = @dateLastUsed,
                 dateModified = @dateModified
          WHERE creditCardId = @creditCardId AND dateLastUsed IS NULL

          SELECT @errorReturn = @@error
       END

       
       IF @errorReturn = 0 
       BEGIN
          COMMIT TRAN TRAN_FixCreditCardLastUsed
          SELECT @rowCountEffected = @rowCountEffected + 1
          IF @rowCountEffected = 10000 or @rowCountEffected = 100000
          BEGIN
             SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
             PRINT @msgReturn 
             SELECT GETDATE()
          END
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: update CreditCard WHERE creditCardId =" + convert(varchar(20),@creditCardId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_FixCreditCardLastUsed
       END 
    END

    FETCH CUR_FixCreditCardLastUsed INTO @creditCardId, @dateLastUsed

END

CLOSE CUR_FixCreditCardLastUsed
DEALLOCATE CURSOR CUR_FixCreditCardLastUsed
SELECT @msgReturn = "WELL DONE with CUR_FixCreditCardLastUsed"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixCreditCardLastUsed') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixCreditCardLastUsed >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixCreditCardLastUsed >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixCreditCardLastUsed','unchained'
go
GRANT EXECUTE ON dbo.wsp_FixCreditCardLastUsed TO web
go

