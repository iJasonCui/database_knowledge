IF OBJECT_ID('dbo.wsp_reverseSDPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_reverseSDPurchase
    IF OBJECT_ID('dbo.wsp_reverseSDPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_reverseSDPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_reverseSDPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         July 2009
**   Description:  reverses SD purchase for user
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_reverseSDPurchase
 @userId         NUMERIC(12,0)
,@xactionId      NUMERIC(12,0)
,@refXactionId   NUMERIC(12,0)
,@contentId      SMALLINT
,@xactionTypeId  TINYINT
,@cardProcessor  CHAR(1)
,@adminUserId    INT
,@adminNote      VARCHAR(255)
,@paymentNumber  VARCHAR(40)
AS

DECLARE
 @return                 INT
,@passes                 SMALLINT
,@passTypeId             TINYINT
,@dateNow                DATETIME
,@balance                INT
,@cost                   NUMERIC(10,2)
,@costUSD                NUMERIC(5,2)
,@tax                    NUMERIC(10,2)
,@taxUSD                 NUMERIC(5,2)
,@currencyId             TINYINT
,@purchaseOfferDetailId  SMALLINT
,@purchaseTypeId         TINYINT
,@billingLocationId      SMALLINT
,@creditCardId           INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN
    SELECT @balance = ISNULL(SUM(balance), 0)
      FROM SDBalance
     WHERE userId = @userId
       AND dateExpiry > @dateNow
    AT ISOLATION READ UNCOMMITTED

    IF @@error != 0
        BEGIN
            RETURN 99
        END

    SELECT  @cost = cost
           ,@costUSD = costUSD
           ,@tax = tax
           ,@taxUSD = taxUSD
           ,@passes = passes
           ,@passTypeId = passTypeId
           ,@creditCardId = creditCardId
           ,@currencyId = currencyId
           ,@purchaseOfferDetailId = purchaseOfferDetailId
           ,@billingLocationId = billingLocationId
           ,@purchaseTypeId = purchaseTypeId 
      FROM SDTransaction t, Purchase p 
     WHERE t.xactionId = p.xactionId
       AND t.xactionId = @refXactionId

    IF @@error != 0
        BEGIN
            RETURN 98
        END

    SELECT @balance = @balance - @passes

    IF @xactionId = -1  -- if reversal not passed through card processor, generate new xactionId and set cardProcessor = null
        BEGIN 
            SELECT @cardProcessor = NULL
            EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT	
            IF @return != 0
	            BEGIN
		            RETURN @return
	            END
        END

    BEGIN TRAN TRAN_reverseSDPurchase
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
            ,-1
            ,@passTypeId
            ,-@passes
            ,@xactionTypeId
            ,@contentId
            ,@dateNow
        )

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN TRAN_reverseSDPurchase
                RETURN 97
            END 

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
            ,xactionTypeId
            ,refXactionId
            ,paymentNumber
        ) VALUES (
             @xactionId
            ,@purchaseTypeId
            ,@billingLocationId
            ,@purchaseOfferDetailId
            ,@currencyId
            ,-@cost
            ,-@costUSD
            ,-@tax
            ,-@taxUSD
            ,@userId
            ,@dateNow
            ,@creditCardId
            ,@cardProcessor
            ,@xactionTypeId
            ,@refXactionId
            ,@paymentNumber
        )

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN TRAN_reverseSDPurchase
                RETURN 96
            END 

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

        IF @@error != 0
            BEGIN
               ROLLBACK TRAN TRAN_reverseSDPurchase
               RETURN 95
            END

        IF EXISTS (SELECT 1 FROM SDBalance WHERE userId = @userId AND passTypeId = @passTypeId)
            BEGIN
                UPDATE SDBalance 
                   SET balance = balance - @passes,
                       dateModified = @dateNow
                 WHERE userId = @userId
                   AND passTypeId = @passTypeId
                
                IF @@error != 0
                    BEGIN
                        ROLLBACK TRAN TRAN_reverseSDPurchase
                        RETURN 94
                    END
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
                    ,-@passes
                    ,@dateNow
                    ,@dateNow
                    ,'20521231'
                )
                
                IF @@error != 0
                    BEGIN
                        ROLLBACK TRAN TRAN_reverseSDPurchase
                        RETURN 93
                    END
	        END

        COMMIT TRAN TRAN_reverseSDPurchase
        RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_reverseSDPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_reverseSDPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_reverseSDPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_reverseSDPurchase TO web
go
