IF OBJECT_ID('dbo.wsp_newSDPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newSDPurchase
    IF OBJECT_ID('dbo.wsp_newSDPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newSDPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newSDPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 1, 2009
**   Description:  Purchase SD passes for user
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newSDPurchase
 @xactionId          NUMERIC(12,0)
,@userId             NUMERIC(12,0)
,@cardId             INT
,@passDetailId       SMALLINT
,@passes             SMALLINT
,@cost               NUMERIC(10,2)
,@tax                NUMERIC(10,2)
,@costUSD            NUMERIC(5,2)
,@taxUSD             NUMERIC(5,2)
,@xactionTypeId      TINYINT
,@contentId          SMALLINT
,@adminUserId        INT
,@paymentNumber      VARCHAR(40)
,@cardProcessor      CHAR(1)

AS
DECLARE
 @return             INT
,@dateNow            DATETIME
,@dateExpiry         DATETIME
,@purchaseTypeId     TINYINT
,@billingLocationId  SMALLINT
,@currencyId         TINYINT
,@passTypeId         SMALLINT
,@balance            SMALLINT

-- stop if xactionId is invalid
IF @xactionId <= 0
    BEGIN
        RETURN 99
    END

-- get @dateNow
EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN 98
    END

-- get number of passes by passDetailId
-- if passes are not passed in
IF @passes <= 0 AND @cost > 0
    BEGIN
        SELECT @passes = credits FROM PurchaseOfferDetail WHERE purchaseOfferDetailId = @passDetailId
        IF @passes <= 0
            BEGIN
                RETURN 97
            END
    END

-- get current balance
EXEC  @return = dbo.wsp_getSDBalance @userId, @balance OUTPUT
IF @return != 0
    BEGIN
        RETURN 96
    END

-- update new balance
SELECT @balance = @balance + @passes

-- get billingLocationId from userId
SELECT @billingLocationId = billingLocationId FROM UserAccount WHERE userId = @userId

-- get currencyId from billingLocationId
SELECT @currencyId = currencyId FROM BillingLocation WHERE billingLocationId = @billingLocationId

-- set other defaults (for SD purchase)
SELECT @dateExpiry = 'December 31 2052'
SELECT @purchaseTypeId = 18
SELECT @passTypeId = 1


BEGIN TRAN TRAN_purchaseCredit

    -- set admin purchase record
    IF @adminUserId > 0
        BEGIN
            INSERT INTO AdminAccountTransaction (
                xactionId
               ,adminUserId
               ,userId
               ,dateCreated
            ) VALUES (
                @xactionId
               ,@adminUserId
               ,@userId
               ,@dateNow
            )
        END

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_purchaseCredit
            RETURN 95
        END

    -- update CreditCard dateLastUsed column
    -- don't need to check for @@error
    IF @cardId > 0
        BEGIN
            UPDATE CreditCard
               SET dateLastUsed = @dateNow
             WHERE creditCardId = @cardId
        END

    -- insert purchase record
    INSERT INTO Purchase (
         xactionId
        ,purchaseTypeId
        ,billingLocationId
        ,purchaseOfferDetailId
        ,currencyId
        ,cost
        ,costUSD
        ,tax
        ,taxUSD
        ,userId
        ,dateCreated
        ,creditCardId
        ,cardProcessor
        ,paymentNumber
        ,xactionTypeId
    ) VALUES (
         @xactionId
        ,@purchaseTypeId
        ,@billingLocationId
        ,@passDetailId
        ,@currencyId
        ,@cost
        ,@costUSD
        ,@tax
        ,@taxUSD
        ,@userId
        ,@dateNow
        ,@cardId
        ,@cardProcessor
        ,@paymentNumber
        ,@xactionTypeId
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_purchaseCredit
            RETURN 94
        END

    -- insert transaction record
    INSERT INTO SDTransaction (
         xactionId
        ,userId
        ,eventId
        ,passTypeId
        ,passes
        ,xactionTypeId
        ,contentId
        ,dateCreated
    ) VALUES (
         @xactionId
        ,@userId
        ,-1 -- purchase
        ,@passTypeId
        ,@passes
        ,@xactionTypeId
        ,@contentId
        ,@dateNow
    )

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_purchaseCredit
            RETURN 93
        END

    -- check passes > 0 because declined purchases don't update balances
    IF @passes > 0
        BEGIN
            IF EXISTS (SELECT 1 FROM SDBalance WHERE userId = @userId AND passTypeId = @passTypeId)
                BEGIN
                    UPDATE SDBalance
                       SET balance = balance + @passes
                          ,dateModified = @dateNow
                          ,dateExpiry = @dateExpiry
                     WHERE userId = @userId
                       AND passTypeId = @passTypeId
                END
            ELSE
                BEGIN
                    INSERT INTO SDBalance (
                         userId
                        ,passTypeId
                        ,balance
                        ,dateCreated
                        ,dateModified
                        ,dateExpiry
                    ) VALUES (
                         @userId
                        ,@passTypeId
                        ,@passes
                        ,@dateNow
                        ,@dateNow
                        ,@dateExpiry
                    )
                END
        END

    IF @@error != 0
        BEGIN
            ROLLBACK TRAN TRAN_purchaseCredit
            RETURN 92
        END

    COMMIT TRAN TRAN_purchaseCredit
    RETURN 0
go

IF OBJECT_ID('dbo.wsp_newSDPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newSDPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newSDPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_newSDPurchase TO web
go
