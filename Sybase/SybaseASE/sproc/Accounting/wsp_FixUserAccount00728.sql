IF OBJECT_ID('dbo.wsp_FixUserAccount00728') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccount00728
    IF OBJECT_ID('dbo.wsp_FixUserAccount00728') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccount00728 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccount00728 >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccount00728
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @purchaseOfferId   int
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

--update UserAccount set purchaseOfferId =3   where purchaseOfferId in (73, 74,75,79,80,81)
--update UserAccount set purchaseOfferId =40 where purchaseOfferId in (76, 77,78,82,83,84)

SELECT userId, purchaseOfferId
INTO #FixUserAccount00728
FROM UserAccount 
WHERE purchaseOfferId >= 73 and purchaseOfferId <= 84

SELECT GETDATE() 

DECLARE CUR_FixUserAccount00728 CURSOR FOR
SELECT userId, purchaseOfferId
FROM   #FixUserAccount00728
FOR READ ONLY

OPEN CUR_FixUserAccount00728
FETCH CUR_FixUserAccount00728 INTO @userId, @purchaseOfferId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccount00728
       DEALLOCATE CURSOR CUR_FixUserAccount00728
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccount00728"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccount00728

       IF @purchaseOfferId in (76, 77,78,82,83,84)
       BEGIN
          UPDATE UserAccount
          SET purchaseOfferId=40, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END
       ELSE BEGIN
          UPDATE UserAccount
          SET purchaseOfferId=3, dateModified = @dateModified
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
                COMMIT TRAN TRAN_FixUserAccount00728
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
                ROLLBACK TRAN TRAN_FixUserAccount00728
             END 
          
          END
          ELSE BEGIN
             SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=1 WHERE userId =" + convert(varchar(20),@userId)
             PRINT @msgReturn          
             ROLLBACK TRAN TRAN_FixUserAccount00728
          END          
    END


    FETCH CUR_FixUserAccount00728 INTO @userId, @purchaseOfferId

END

CLOSE CUR_FixUserAccount00728
DEALLOCATE CURSOR CUR_FixUserAccount00728
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccount00728"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccount00728') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccount00728 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccount00728 >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccount00728','unchained'
go

