IF OBJECT_ID('dbo.wsp_FixUserAccount00655') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccount00655
    IF OBJECT_ID('dbo.wsp_FixUserAccount00655') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccount00655 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccount00655 >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccount00655
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @billingLocationId   int
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

--UPDATE UserAccount SET purchaseOfferId = 40, dateModified = @dateNow WHERE billingLocationId = 29
--UPDATE UserAccount SET purchaseOfferId = 1,  dateModified = @dateNow
--WHERE billingLocationId IN (2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28)

SELECT userId, billingLocationId
INTO #FixUserAccount00655
FROM UserAccount 
WHERE billingLocationId IN (2, 3, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29)

SELECT GETDATE() 

DECLARE CUR_FixUserAccount00655 CURSOR FOR
SELECT userId, billingLocationId
FROM   #FixUserAccount00655
FOR READ ONLY

OPEN CUR_FixUserAccount00655
FETCH CUR_FixUserAccount00655 INTO @userId, @billingLocationId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccount00655
       DEALLOCATE CURSOR CUR_FixUserAccount00655
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccount00655"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccount00655

       IF @billingLocationId = 29
       BEGIN
          UPDATE UserAccount
          SET purchaseOfferId=40, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END
       ELSE BEGIN
          UPDATE UserAccount
          SET purchaseOfferId=1, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END

       IF @errorReturn = 0
       BEGIN
         
             INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
             SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
             FROM UserAccount WHERE userId = @userId	    
           
             IF @@error = 0 
             BEGIN
                COMMIT TRAN TRAN_FixUserAccount00655
                SELECT @rowCountEffected = @rowCountEffected + 1
                IF @rowCountEffected = 10000 or @rowCountEffected = 20000
                BEGIN
                   SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
                   PRINT @msgReturn 
                   SELECT GETDATE()
                END
             END
             ELSE BEGIN
                SELECT @msgReturn = "Error: INSERT UserAccountHistory WHERE userId =" + convert(varchar(20),@userId)
                PRINT @msgReturn          
                ROLLBACK TRAN TRAN_FixUserAccount00655
             END 
          
          END
          ELSE BEGIN
             SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=1 WHERE userId =" + convert(varchar(20),@userId)
             PRINT @msgReturn          
             ROLLBACK TRAN TRAN_FixUserAccount00655
          END          
    END


    FETCH CUR_FixUserAccount00655 INTO @userId, @billingLocationId

END

CLOSE CUR_FixUserAccount00655
DEALLOCATE CURSOR CUR_FixUserAccount00655
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccount00655"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccount00655') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccount00655 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccount00655 >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccount00655','unchained'
go
GRANT EXECUTE ON dbo.wsp_FixUserAccount00655 TO web
go

