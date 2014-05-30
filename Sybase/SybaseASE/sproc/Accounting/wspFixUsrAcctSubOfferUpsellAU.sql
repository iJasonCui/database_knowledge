IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellAU') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU
    IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellAU') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU >>>'
END
go
CREATE PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU
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
into mda_db..upsell_au
from Accounting..UserAccount u, Member..user_info m 
where subscriptionOfferId=81
and u.userId=m.user_id 
and m.subscriptionStatus="A" 
and u.accountType="S"
*/

    SELECT GETDATE() 
    DECLARE CUR_FixUserAccount CURSOR FOR
    SELECT userId 
      FROM tempdb..upsell_au
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
if exists (select 1 from UserSubscriptionAccount  where userId=@userId and subscriptionOfferDetailId in (366,367) and subscriptionStatus="A" )
begin
     update UserAccount set subscriptionOfferId=11, dateModified = @dateModified where userId=@userId

     update UserSubscriptionAccount set subscriptionOfferDetailId=22, dateModified = @dateModified   where userId=@userId and subscriptionOfferDetailId=366
     update UserSubscriptionAccount set subscriptionOfferDetailId=23 , dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=367
     
end
-- switch to Subscription DialBack if this user is an active premium intimate Premium user or Inactive user (the others)
else  begin
     update UserAccount set subscriptionOfferId=84, dateModified = @dateModified  where userId=@userId
     
     update UserSubscriptionAccount set subscriptionOfferDetailId=390, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=368
     update UserSubscriptionAccount set subscriptionOfferDetailId=391, dateModified = @dateModified  where userId=@userId and subscriptionOfferDetailId=369

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
EXEC sp_procxmode 'dbo.wspFixUsrAcctSubOfferUpsellAU','unchained'
go
IF OBJECT_ID('dbo.wspFixUsrAcctSubOfferUpsellAU') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wspFixUsrAcctSubOfferUpsellAU >>>'
go

