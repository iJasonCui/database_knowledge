IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellUS') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS
    IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellUS') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS >>>'
END
go

CREATE PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS
AS
BEGIN
    DECLARE @userId         NUMERIC(12,0)
    DECLARE @rowCount       INT
    DECLARE @msgReturn      VARCHAR(255)
    DECLARE @dateModified   DATETIME

    SELECT GETDATE()
    SELECT @rowCount = 0

    EXEC wsp_GetDateGMT @dateModified OUTPUT

/*
select  u.userId 
into mda_db..upsell_us1
from Accounting..UserAccount u, Member..user_info m 
where subscriptionOfferId=80 
and u.userId=m.user_id 
and m.subscriptionStatus="A" 
and u.accountType="S"
*/

    SELECT GETDATE() 
    DECLARE CUR_FixUserAccount CURSOR FOR
    SELECT userId 
      FROM tempdb..upsell_us1
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
    
-- switch to Subscription Roll-out if this user is an active premium intimate STANDARD user 
if exists (select 1 from UserSubscriptionAccount  where userId=@userId and subscriptionOfferDetailId in (362,363) and subscriptionStatus="A" )
begin
     update UserAccount set subscriptionOfferId=9, dateModified = @dateModified where userId=@userId

     update UserSubscriptionAccount set subscriptionOfferDetailId=18, dateModified = @dateModified   where userId=@userId and subscriptionOfferDetailId=362
     update UserSubscriptionAccount set subscriptionOfferDetailId=19 , dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=363
     update UserSubscriptionAccount set subscriptionOfferDetailId=100, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=376
     update UserSubscriptionAccount set subscriptionOfferDetailId=101, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=377
end
-- switch to Subscription DialBack if this user is an active premium intimate Premium user or Inactive user (the others)
else  begin
     update UserAccount set subscriptionOfferId=82, dateModified = @dateModified  where userId=@userId
     
     update UserSubscriptionAccount set subscriptionOfferDetailId=380, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=364
     update UserSubscriptionAccount set subscriptionOfferDetailId=381, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=365
     update UserSubscriptionAccount set subscriptionOfferDetailId=382, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=378
     update UserSubscriptionAccount set subscriptionOfferDetailId=383, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=379
end

            IF @@error != 0
            BEGIN
                SELECT @msgReturn = 'Error: UPDATE UserAccount SET subscriptionOfferId =  WHERE userId = ' + CONVERT(VARCHAR(20), @userId)
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
EXEC sp_procxmode 'dbo.wspFixUsrAcctSubOfferUpsellUS','unchained'
go
IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellUS') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellUS >>>'
go

