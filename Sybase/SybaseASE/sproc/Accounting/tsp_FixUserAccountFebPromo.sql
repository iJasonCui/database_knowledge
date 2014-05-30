IF OBJECT_ID('dbo.tsp_FixUserAccountFebPromo') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.tsp_FixUserAccountFebPromo
    IF OBJECT_ID('dbo.tsp_FixUserAccountFebPromo') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.tsp_FixUserAccountFebPromo >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.tsp_FixUserAccountFebPromo >>>'
END
go

CREATE PROCEDURE dbo.tsp_FixUserAccountFebPromo
 @oldSubOfferId INT
,@newSubOfferId INT

AS
BEGIN
    DECLARE @userId      NUMERIC(12,0)
    DECLARE @rowCount    INT
    DECLARE @msgReturn   VARCHAR(255)
    DECLARE @dateNow     DATETIME
    DECLARE @dateCutoff  DATETIME

    SELECT GETDATE()
    SELECT @rowCount = 0
    SELECT @dateCutoff = 'Feb 1 2011'

    EXEC wsp_GetDateGMT @dateNow OUTPUT

    -- SET ROWCOUNT 10
    SELECT userId
      INTO #FixUserAccount
      FROM Accounting..UserAccount
     WHERE accountType = 'S'
       AND subscriptionOfferId = @oldSubOfferId
       AND dateCreated >= @dateCutoff
    -- SET ROWCOUNT 0

    SELECT GETDATE() 
    DECLARE CUR_FixUserAccount CURSOR FOR

    SELECT userId
      FROM #FixUserAccount
    FOR READ ONLY

    OPEN CUR_FixUserAccount
    FETCH CUR_FixUserAccount INTO @userId

    WHILE @@sqlstatus != 2
    BEGIN
        IF @@sqlstatus = 1
        BEGIN
            SELECT @msgReturn = 'ERROR: There is something wrong with CUR_FixUserAccount'
            PRINT @msgReturn
            CLOSE CUR_FixUserAccount
            DEALLOCATE CURSOR CUR_FixUserAccount
            RETURN 99
        END

        IF NOT EXISTS (SELECT 1 FROM UserSubscriptionAccount WHERE userId = @userId AND subscriptionEndDate > @dateNow)
        BEGIN
            BEGIN TRAN TRAN_FixUserAccount

                UPDATE UserAccount
                   SET subscriptionOfferId = @newSubOfferId, dateModified = @dateNow
                 WHERE userId = @userId

                IF @@error != 0
                BEGIN
                    SELECT @msgReturn = 'Error: UPDATE UserAccount SET subscriptionOfferId = ' + CONVERT(VARCHAR(20), @newSubOfferId) + ' WHERE userId = ' + CONVERT(VARCHAR(20), @userId)
                    PRINT @msgReturn
                    ROLLBACK TRAN TRAN_FixUserAccount
                    CLOSE CUR_FixUserAccount
                    DEALLOCATE CURSOR CUR_FixUserAccount
                    RETURN 98
                END

                INSERT UserAccountHistory (userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry, subscriptionOfferId)
                SELECT userId, billingLocationId, purchaseOfferId, usageCellId, accountType, dateCreated, dateModified, dateExpiry, subscriptionOfferId
                FROM UserAccount WHERE userId = @userId

                IF @@error != 0
                BEGIN
                    SELECT @msgReturn = 'Error: INSERT UserAccountHistory WHERE userId = ' + CONVERT(VARCHAR(20), @userId)
                    PRINT @msgReturn
                    ROLLBACK TRAN TRAN_FixUserAccount
                    CLOSE CUR_FixUserAccount
                    DEALLOCATE CURSOR CUR_FixUserAccount
                    RETURN 97
                END

                COMMIT TRAN TRAN_FixUserAccount
                SELECT @rowCount = @rowCount + 1

                IF @rowCount = 10000 OR @rowCount = 20000 OR @rowCount = 30000 OR @rowCount = 40000 OR @rowCount = 50000
                BEGIN
                    SELECT @msgReturn = CONVERT(VARCHAR(20), @rowCount) + ' HAS BEEN EFFECTED'
                    PRINT @msgReturn
                    SELECT GETDATE()
                END
        END
        FETCH CUR_FixUserAccount INTO @userId
    END

    SELECT @msgReturn = 'WELL DONE with CUR_FixUserAccount'
    PRINT @msgReturn
    SELECT @msgReturn = CONVERT(VARCHAR(20), @rowCount) + ' ROWS HAS BEEN EFFECTED'
    PRINT @msgReturn
    SELECT GETDATE() 
    CLOSE CUR_FixUserAccount
    DEALLOCATE CURSOR CUR_FixUserAccount
END
go

IF OBJECT_ID('dbo.tsp_FixUserAccountFebPromo') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.tsp_FixUserAccountFebPromo >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.tsp_FixUserAccountFebPromo >>>'
go

EXEC sp_procxmode 'dbo.tsp_FixUserAccountFebPromo','unchained'
go

GRANT EXECUTE ON dbo.tsp_FixUserAccountFebPromo TO web
go
