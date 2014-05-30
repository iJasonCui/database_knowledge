IF OBJECT_ID('dbo.wsp_FixUserAccount00402UK') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccount00402UK
    IF OBJECT_ID('dbo.wsp_FixUserAccount00402UK') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccount00402UK >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccount00402UK >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccount00402UK
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

--UPDATE UserAccount SET purchaseOfferId = 60 WHERE billingLocationId = 16 -- UNITED KINGDOM

SELECT userId 
INTO #FixUserAccount00402UK
FROM UserAccount WHERE billingLocationId = 16 

DECLARE CUR_FixUserAccount00402UK CURSOR FOR
SELECT userId
FROM   #FixUserAccount00402UK
FOR READ ONLY

OPEN CUR_FixUserAccount00402UK
FETCH CUR_FixUserAccount00402UK INTO @userId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccount00402UK
       DEALLOCATE CURSOR CUR_FixUserAccount00402UK
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccount00402UK"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccount00402UK
       
       UPDATE UserAccount
       SET purchaseOfferId=60, dateModified = @dateModified
       WHERE userId = @userId
       
       IF @@error = 0
       BEGIN
         
          INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
          SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
          FROM UserAccount WHERE userId = @userId	    
           
          IF @@error = 0 
          BEGIN
             COMMIT TRAN TRAN_FixUserAccount00402UK
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
             ROLLBACK TRAN TRAN_FixUserAccount00402UK
          END 
          
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=3 WHERE userId =" + convert(varchar(20),@userId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_FixUserAccount00402UK
       END          
    END

    FETCH CUR_FixUserAccount00402UK INTO @userId

END

CLOSE CUR_FixUserAccount00402UK
DEALLOCATE CURSOR CUR_FixUserAccount00402UK
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccount00402UK"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccount00402UK') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccount00402UK >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccount00402UK >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccount00402UK','unchained'
go

