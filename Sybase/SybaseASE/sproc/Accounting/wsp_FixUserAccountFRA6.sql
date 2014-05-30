IF OBJECT_ID('dbo.wsp_FixUserAccountFRA6') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccountFRA6
    IF OBJECT_ID('dbo.wsp_FixUserAccountFRA6') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccountFRA6 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccountFRA6 >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccountFRA6
AS
BEGIN

DECLARE @userId              numeric(12,0)
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

SELECT userId 
INTO #FixUserAccountFRA6
FROM UserAccount WHERE billingLocationId = 6 

DECLARE CUR_FixUserAccountFRA6 CURSOR FOR
SELECT userId
FROM   #FixUserAccountFRA6
FOR READ ONLY

OPEN CUR_FixUserAccountFRA6
FETCH CUR_FixUserAccountFRA6 INTO @userId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccountFRA6
       DEALLOCATE CURSOR CUR_FixUserAccountFRA6
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccountFRA6"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccountFRA6
       
       UPDATE UserAccount
       SET purchaseOfferId=41, dateModified = @dateModified
       WHERE userId = @userId
       
       IF @@error = 0
       BEGIN
         
          INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
          SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
          FROM UserAccount WHERE userId = @userId	    
           
          IF @@error = 0 
          BEGIN
             COMMIT TRAN TRAN_FixUserAccountFRA6
             SELECT @rowCountEffected = @rowCountEffected + 1
          END
          ELSE BEGIN
             SELECT @msgReturn = "Error: INSERT UserAccountHistory WHERE userId =" + convert(varchar(20),@userId)
             PRINT @msgReturn          
             ROLLBACK TRAN TRAN_FixUserAccountFRA6
          END 
          
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=3 WHERE userId =" + convert(varchar(20),@userId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_FixUserAccountFRA6
       END          
    END

    FETCH CUR_FixUserAccountFRA6 INTO @userId

END

CLOSE CUR_FixUserAccountFRA6
DEALLOCATE CURSOR CUR_FixUserAccountFRA6
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccountFRA6"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
        
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccountFRA6') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccountFRA6 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccountFRA6 >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccountFRA6','unchained'
go

