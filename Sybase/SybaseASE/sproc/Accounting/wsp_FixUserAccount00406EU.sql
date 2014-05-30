IF OBJECT_ID('dbo.wsp_FixUserAccount00406EU') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccount00406EU
    IF OBJECT_ID('dbo.wsp_FixUserAccount00406EU') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccount00406EU >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccount00406EU >>>'
END
go
CREATE PROCEDURE dbo.wsp_FixUserAccount00406EU
AS
BEGIN

SELECT GETDATE()

DECLARE @userId              numeric(12,0)
DECLARE @purchaseOfferId     smallint 
DECLARE @billingLocationId   smallint
DECLARE @errorReturn         int
DECLARE @rowCountEffected    int
DECLARE @msgReturn           varchar(255)
DECLARE @dateModified        DATETIME

SELECT @rowCountEffected = 0 

EXEC wsp_GetDateGMT @dateModified OUTPUT

-- UPDATE UserAccount SET purchaseOfferId = 48, dateModified = @dateGMT WHERE billingLocationId = 2  -- AUSTRIA
-- UPDATE UserAccount SET purchaseOfferId = 51, dateModified = @dateGMT WHERE billingLocationId = 6  -- FRANCE
-- UPDATE UserAccount SET purchaseOfferId = 52, dateModified = @dateGMT WHERE billingLocationId = 7  -- GERMANY
-- UPDATE UserAccount SET purchaseOfferId = 55, dateModified = @dateGMT WHERE billingLocationId = 10 -- ITALY
-- UPDATE UserAccount SET purchaseOfferId = 59, dateModified = @dateGMT WHERE billingLocationId = 14 -- SPAIN
-- UPDATE UserAccount SET purchaseOfferId = 49, dateModified = @dateGMT WHERE billingLocationId = 3  -- BELGIUM
-- UPDATE UserAccount SET purchaseOfferId = 50, dateModified = @dateGMT WHERE billingLocationId = 5  -- FINLAND
-- UPDATE UserAccount SET purchaseOfferId = 53, dateModified = @dateGMT WHERE billingLocationId = 8  -- GREECE
-- UPDATE UserAccount SET purchaseOfferId = 54, dateModified = @dateGMT WHERE billingLocationId = 9  -- IRELAND
-- UPDATE UserAccount SET purchaseOfferId = 56, dateModified = @dateGMT WHERE billingLocationId = 11 -- LUXEMBOURG
-- UPDATE UserAccount SET purchaseOfferId = 57, dateModified = @dateGMT WHERE billingLocationId = 12 -- NETHERLANDS
-- UPDATE UserAccount SET purchaseOfferId = 58, dateModified = @dateGMT WHERE billingLocationId = 13 -- PORTUGAL

SELECT userId, 
       CASE when billingLocationId = 2  then 48
            when billingLocationId = 6  then 51
            when billingLocationId = 7  then 52
            when billingLocationId = 10 then 55
            when billingLocationId = 14 then 59
            when billingLocationId = 3  then 49
            when billingLocationId = 5  then 50
            when billingLocationId = 8  then 53
            when billingLocationId = 9  then 54
            when billingLocationId = 11 then 56
            when billingLocationId = 12 then 57
            when billingLocationId = 13 then 58
       END as purchaseOfferId     
INTO #FixUserAccount00406EU
FROM UserAccount WHERE billingLocationId in (2,6,7,10,14,3,5,8,9,11,12,13)

DECLARE CUR_FixUserAccount00406EU CURSOR FOR
SELECT userId, purchaseOfferId 
FROM   #FixUserAccount00406EU
FOR READ ONLY

OPEN CUR_FixUserAccount00406EU
FETCH CUR_FixUserAccount00406EU INTO @userId, @purchaseOfferId

WHILE @@sqlstatus != 2
BEGIN
    IF @@sqlstatus = 1
    BEGIN
       CLOSE CUR_FixUserAccount00406EU
       DEALLOCATE CURSOR CUR_FixUserAccount00406EU
       SELECT @msgReturn = "error: there is something wrong with CUR_FixUserAccount00406EU"
       PRINT @msgReturn
       RETURN 99
    END
    ELSE BEGIN
       BEGIN TRAN TRAN_FixUserAccount00406EU
       
       UPDATE UserAccount
       SET purchaseOfferId = @purchaseOfferId, dateModified = @dateModified
       WHERE userId = @userId
       
       IF @@error = 0
       BEGIN
         
          INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry)
          SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry
          FROM UserAccount WHERE userId = @userId	    
           
          IF @@error = 0 
          BEGIN
             COMMIT TRAN TRAN_FixUserAccount00406EU
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
             ROLLBACK TRAN TRAN_FixUserAccount00406EU
          END 
          
       END
       ELSE BEGIN
          SELECT @msgReturn = "Error: UPDATE UserAccount SET purchaseOfferId=3 WHERE userId =" + convert(varchar(20),@userId)
          PRINT @msgReturn          
          ROLLBACK TRAN TRAN_FixUserAccount00406EU
       END          
    END

    FETCH CUR_FixUserAccount00406EU INTO @userId, @purchaseOfferId

END

CLOSE CUR_FixUserAccount00406EU
DEALLOCATE CURSOR CUR_FixUserAccount00406EU
SELECT @msgReturn = "WELL DONE with CUR_FixUserAccount00406EU"
PRINT @msgReturn
SELECT @msgReturn = CONVERT(VARCHAR(20),@rowCountEffected) + " HAS BEEN EFFECTED"
PRINT @msgReturn
SELECT GETDATE() 
 
END

go
IF OBJECT_ID('dbo.wsp_FixUserAccount00406EU') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccount00406EU >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccount00406EU >>>'
go
EXEC sp_procxmode 'dbo.wsp_FixUserAccount00406EU','unchained'
go

