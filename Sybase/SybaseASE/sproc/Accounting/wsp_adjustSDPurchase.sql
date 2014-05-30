IF OBJECT_ID('dbo.wsp_adjustSDPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adjustSDPurchase
    IF OBJECT_ID('dbo.wsp_adjustSDPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adjustSDPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adjustSDPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         July 2009
**   Description:  adjusts SD purchase for user
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adjustSDPurchase
 @userId         NUMERIC(12,0)
,@xactionId      NUMERIC(12,0)
,@refXactionId   NUMERIC(12,0)
,@contentId      SMALLINT
,@xactionTypeId  TINYINT
,@cardProcessor  CHAR(1)
,@adminUserId    INT
,@adminNote      VARCHAR(255)
AS

DECLARE
 @return                 INT
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

    BEGIN TRAN TRAN_adjustSDPurchase
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
            ,0
            ,@xactionTypeId
            ,@contentId
            ,@dateNow
        )

        IF @@error != 0
            BEGIN
	            ROLLBACK TRAN TRAN_adjustSDPurchase
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
        ) VALUES (
             @xactionId
            ,@purchaseTypeId
            ,@billingLocationId
            ,@purchaseOfferDetailId
            ,@currencyId
            ,0
            ,0
            ,0
            ,0
            ,@userId
            ,@dateNow
            ,@creditCardId
            ,@cardProcessor
            ,@xactionTypeId
            ,@refXactionId
        )

        IF @@error != 0
            BEGIN
                ROLLBACK TRAN TRAN_adjustSDPurchase
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
               ROLLBACK TRAN TRAN_adjustSDPurchase
               RETURN 95
            END

        COMMIT TRAN TRAN_adjustSDPurchase
        RETURN 0
END
go

IF OBJECT_ID('dbo.wsp_adjustSDPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adjustSDPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adjustSDPurchase >>>'
go

GRANT EXECUTE ON dbo.wsp_adjustSDPurchase TO web
go


