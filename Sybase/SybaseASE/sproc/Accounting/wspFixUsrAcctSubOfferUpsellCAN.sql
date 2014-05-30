IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellCAN') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN
    IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellCAN') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN >>>'
END
go
CREATE PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN
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
into mda_db..upsell_ca
from Accounting..UserAccount u, Member..user_info m 
where subscriptionOfferId=79 
and u.userId=m.user_id 
and m.subscriptionStatus="A" 
and u.accountType="S"
*/

    SELECT GETDATE() 
    DECLARE CUR_FixUserAccount CURSOR FOR
    SELECT userId 
      FROM tempdb..upsell_ca
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
if exists (select 1 from UserSubscriptionAccount  where userId=@userId and subscriptionOfferDetailId in (356,357, 358) and subscriptionStatus="A" )
begin
     update UserAccount set subscriptionOfferId=10, dateModified = @dateModified where userId=@userId

     update UserSubscriptionAccount set subscriptionOfferDetailId=20, dateModified = @dateModified   where userId=@userId and subscriptionOfferDetailId=356
     update UserSubscriptionAccount set subscriptionOfferDetailId=21 , dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=357
     update UserSubscriptionAccount set subscriptionOfferDetailId=163, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=358
     update UserSubscriptionAccount set subscriptionOfferDetailId=102, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=370
     update UserSubscriptionAccount set subscriptionOfferDetailId=103, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=371
     update UserSubscriptionAccount set subscriptionOfferDetailId=162, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=372     
end
-- switch to Subscription DialBack if this user is an active premium intimate Premium user or Inactive user (the others)
else  begin
     update UserAccount set subscriptionOfferId=83, dateModified = @dateModified  where userId=@userId
     
     update UserSubscriptionAccount set subscriptionOfferDetailId=384, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=359
     update UserSubscriptionAccount set subscriptionOfferDetailId=385, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=360
     update UserSubscriptionAccount set subscriptionOfferDetailId=386, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=361
     update UserSubscriptionAccount set subscriptionOfferDetailId=387, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=373
     update UserSubscriptionAccount set subscriptionOfferDetailId=388, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=374
     update UserSubscriptionAccount set subscriptionOfferDetailId=389, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=375     
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
EXEC sp_procxmode 'dbo.wspFixUsrAcctSubOfferUpsellCAN','unchained'
go
IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellCAN') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellCAN >>>'
go

