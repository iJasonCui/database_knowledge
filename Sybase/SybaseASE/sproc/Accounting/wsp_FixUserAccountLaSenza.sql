IF OBJECT_ID('dbo.wsp_FixUserAccountLaSenza') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccountLaSenza
    IF OBJECT_ID('dbo.wsp_FixUserAccountLaSenza') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccountLaSenza >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccountLaSenza >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccountLaSenza
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @purchaseOfferId     INT
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

-- Revert LaSenza Purchase Offer
--update UserAccount set purchaseOfferId = 3 where purchaseOfferId = 31 -- Canada
--update UserAccount set purchaseOfferId = 1 where purchaseOfferId = 30 -- USA

SELECT userId , purchaseOfferId
INTO #FixUserAccountLaSenza
FROM UserAccount 
WHERE purchaseOfferId in (30,31)

DECLARE CUR_FixUserAccountLaSenza CURSOR FOR
SELECT userId, purchaseOfferId
FROM   #FixUserAccountLaSenza
FOR READ ONLY

OPEN CUR_FixUserAccountLaSenza
FETCH CUR_FixUserAccountLaSenza INTO @userId, @purchaseOfferId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccountLaSenza
       DEALLOCATE CURSOR CUR_FixUserAccountLaSenza
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccountLaSenza"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccountLaSenza
      
       IF @purchaseOfferId = 31 
       UPDATE UserAccount
       SET purchaseOfferId = 3 , dateModified = @dateModified
       WHERE userId = @userId  and purchaseOfferId = 31

       IF @purchaseOfferId = 30
       UPDATE UserAccount
       SET purchaseOfferId = 1 , dateModified = @dateModified
       WHERE userId = @userId  and purchaseOfferId = 30
      
        
       IF @@error = 0
       BEGIN
         
          INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
          SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
          FROM UserAccount WHERE userId = @userId	    
           
          IF @@error = 0 
          BEGIN
             COMMIT TRAN TRAN_FixUserAccountLaSenza
             SELECT @rowCountEffected = @rowCountEffected + 1
             IF @rowCountEffected = 100000 or @rowCountEffected = 200000 
             BEGIN
                SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
                PRINT @msgReturn 
                SELECT GETDATE()
             END
          END
          ELSE BEGIN
             SELECT @msgReturn = "Error: INSERT UserAccountHistory WHERE userId =" + convert(varchar(20),@userId)
             PRINT @msgReturn          
             ROLLBACK TRAN TRAN_FixUserAccountLaSenza
          END 
          
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=3 WHERE userId =" + convert(varchar(20),@userId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_FixUserAccountLaSenza
       END          
    END

    FETCH CUR_FixUserAccountLaSenza INTO @userId, @purchaseOfferId

END

CLOSE CUR_FixUserAccountLaSenza
DEALLOCATE CURSOR CUR_FixUserAccountLaSenza
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccountLaSenza"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccountLaSenza') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccountLaSenza >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccountLaSenza >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccountLaSenza','unchained'
go

