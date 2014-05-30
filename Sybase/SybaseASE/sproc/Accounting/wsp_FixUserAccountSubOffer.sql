IF OBJECT_ID('dbo.wsp_FixUserAccountSubOffer') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_FixUserAccountSubOffer
    IF OBJECT_ID('dbo.wsp_FixUserAccountSubOffer') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_FixUserAccountSubOffer >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_FixUserAccountSubOffer >>>'
END
go

CREATE PROCEDURE dbo.wsp_FixUserAccountSubOffer
 @oldSubOfferId INT
,@newSubOfferId INT
,@userType               CHAR(1)

AS
BEGIN
    DECLARE @userId         NUMERIC(12,0)
    DECLARE @rowCount       INT
    DECLARE @msgReturn      VARCHAR(255)
    DECLARE @dateModified   DATETIME

    SELECT GETDATE()
    SELECT @rowCount = 0

    EXEC wsp_GetDateGMT @dateModified OUTPUT

    -- SET ROWCOUNT 10
    SELECT a.userId
      INTO #FixUserAccount
      FROM Accounting..UserAccount a, Member..user_info m 
     WHERE a.userId = m.user_id
       AND m.user_type = @userType
       AND m.status = 'A'
       AND a.accountType = 'S'
       AND a.subscriptionOfferId = @oldSubOfferId
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

        BEGIN TRAN TRAN_FixUserAccount

            -- SELECT @msgReturn = 'Error: UPDATE UserAccount SET subscriptionOfferId = ' + CONVERT(VARCHAR(20), @newSubOfferId) + ' WHERE userId = ' + CONVERT(VARCHAR(20), @userId)
            -- PRINT @msgReturn

            UPDATE UserAccount
            SET subscriptionOfferId = @newSubOfferId, dateModified = @dateModified
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

IF OBJECT_ID('dbo.wsp_FixUserAccountSubOffer') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_FixUserAccountSubOffer >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_FixUserAccountSubOffer >>>'
go

EXEC sp_procxmode 'dbo.wsp_FixUserAccountSubOffer','unchained'
go

GRANT EXECUTE ON dbo.wsp_FixUserAccountSubOffer TO web
go
