IF OBJECT_ID('dbo.wsp_FixUserAccount4065PR') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccount4065PR
    IF OBJECT_ID('dbo.wsp_FixUserAccount4065PR') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccount4065PR >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccount4065PR >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccount4065PR
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @subscriptionOfferId   int
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

--update UserAccount set subscriptionOfferId = 9 where subscriptionOfferId = 31
--update UserAccount set subscriptionOfferId = 10 where subscriptionOfferId = 32
--update UserAccount set subscriptionOfferId = 11 where subscriptionOfferId = 33

SELECT userId, subscriptionOfferId
INTO #FixUserAccount4065PR
FROM UserAccount 
WHERE subscriptionOfferId >= 31 and subscriptionOfferId <= 33

SELECT GETDATE() 

DECLARE CUR_FixUserAccount4065PR CURSOR FOR
SELECT userId, subscriptionOfferId
FROM   #FixUserAccount4065PR
FOR READ ONLY

OPEN CUR_FixUserAccount4065PR
FETCH CUR_FixUserAccount4065PR INTO @userId, @subscriptionOfferId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccount4065PR
       DEALLOCATE CURSOR CUR_FixUserAccount4065PR
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccount4065PR"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccount4065PR

       IF @subscriptionOfferId = 31
       BEGIN
          UPDATE UserAccount
          SET subscriptionOfferId = 9, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END
       
       IF @subscriptionOfferId = 32
       BEGIN
          UPDATE UserAccount
          SET subscriptionOfferId = 10, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END


       IF @subscriptionOfferId = 33
       BEGIN
          UPDATE UserAccount
          SET subscriptionOfferId = 11, dateModified = @dateModified
          WHERE userId = @userId
       
          SELECT @errorReturn = @@error
       END

       IF @errorReturn = 0
       BEGIN
         
             INSERT UserAccountHistory (userId,billingLocationId, subscriptionOfferId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
             SELECT userId, billingLocationId,subscriptionOfferId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
             FROM UserAccount WHERE userId = @userId	    
           
             IF @@error = 0 
             BEGIN
                COMMIT TRAN TRAN_FixUserAccount4065PR
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
                ROLLBACK TRAN TRAN_FixUserAccount4065PR
             END 
          
       END
       ELSE BEGIN
             SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=1 WHERE userId =" + convert(varchar(20),@userId)
             PRINT @msgReturn          
             ROLLBACK TRAN TRAN_FixUserAccount4065PR
       END          
    END


    FETCH CUR_FixUserAccount4065PR INTO @userId, @subscriptionOfferId

END

CLOSE CUR_FixUserAccount4065PR
DEALLOCATE CURSOR CUR_FixUserAccount4065PR
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccount4065PR"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END


go
EXEC sp_procxmode 'dbo.wsp_FixUserAccount4065PR','unchained'
go
IF OBJECT_ID('dbo.wsp_FixUserAccount4065PR') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccount4065PR >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccount4065PR >>>'
go
GRANT EXECUTE ON dbo.wsp_FixUserAccount4065PR TO web
go

