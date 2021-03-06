IF OBJECT_ID('dbo.wspFixBadCreditCardLastCreated') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wspFixBadCreditCardLastCreated
    IF OBJECT_ID('dbo.wspFixBadCreditCardLastCreated') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wspFixBadCreditCardLastCreated >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wspFixBadCreditCardLastCreated >>>'
END
go
CREATE PROCEDURE dbo.wspFixBadCreditCardLastCreated
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

DECLARE CUR_FixCreditCardLastCreated CURSOR FOR
SELECT creditCardId , dateLastUsed 
FROM   tempdb..BadCreditCardLastCreated 
FOR READ ONLY

OPEN CUR_FixCreditCardLastCreated
FETCH CUR_FixCreditCardLastCreated INTO @creditCardId, @dateLastUsed

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixCreditCardLastCreated
       DEALLOCATE CURSOR CUR_FixCreditCardLastCreated
       SELECT @msgReturn = "error: there is something wrong with CUR_FixCreditCardLastCreated"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixCreditCardLastCreated

       UPDATE CreditCard
       SET    dateLastUsed = @dateLastUsed,
              dateModified = @dateModified
       WHERE creditCardId = @creditCardId AND dateLastUsed IS NULL AND status = 'B'

       SELECT @errorReturn = @@error
       
       IF @errorReturn = 0 
       BEGIN
          COMMIT TRAN TRAN_FixCreditCardLastCreated
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
          ROLLBACK TRAN TRAN_FixCreditCardLastCreated
       END 
    END

    FETCH CUR_FixCreditCardLastCreated INTO @creditCardId, @dateLastUsed

END

CLOSE CUR_FixCreditCardLastCreated
DEALLOCATE CURSOR CUR_FixCreditCardLastCreated
SELECT @msgReturn = "WELL DONE with CUR_FixCreditCardLastCreated"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wspFixBadCreditCardLastCreated') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wspFixBadCreditCardLastCreated >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wspFixBadCreditCardLastCreated >>>'
go
EXEC sp_procxmode 'dbo.wspFixBadCreditCardLastCreated','unchained'
go

