IF OBJECT_ID('dbo.wsp_bibitReversePurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_bibitReversePurchase
    IF OBJECT_ID('dbo.wsp_bibitReversePurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_bibitReversePurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_bibitReversePurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Feb 10, 2004
**   Description:  reverses  bibit purchase for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_bibitReversePurchase
 @refXactionId    NUMERIC(12,0)
,@xactionTypeId   TINYINT
,@contentId       SMALLINT
AS

DECLARE @return 		INT
,@userId                        NUMERIC(12,0)
,@xactionId                     NUMERIC(12,0)
,@credits                       SMALLINT
,@creditTypeId                  TINYINT
,@dateNow 			DATETIME
,@balance                       INT
,@cost                          NUMERIC (10,2)
,@costUSD                       NUMERIC (5,2)
,@tax                           NUMERIC (10,2)
,@taxUSD                        NUMERIC (5,2)
,@cardProcessor                 CHAR(1)
,@currencyId                    TINYINT
,@purchaseOfferDetailId         SMALLINT
,@purchaseTypeId                TINYINT
,@billingLocationId             SMALLINT
,@creditCardId                  INT

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END


EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT

IF @return != 0
	BEGIN
		RETURN @return
	END

SELECT @userId = AccountTransaction.userId,
       @cost=cost,
       @costUSD=costUSD,
       @tax=tax,
       @taxUSD=taxUSD,
       @credits = credits,
       @creditTypeId = creditTypeId,
       @creditCardId = creditCardId,
       @cardProcessor=cardProcessor,
       @currencyId=currencyId,
       @purchaseOfferDetailId=purchaseOfferDetailId,
       @billingLocationId=billingLocationId,
       @purchaseTypeId=purchaseTypeId 
     FROM AccountTransaction,Purchase
     WHERE AccountTransaction.xactionId=@refXactionId AND
       AccountTransaction.xactionId=Purchase.xactionId

SELECT @balance = @balance - @credits

EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT	

IF @return != 0
BEGIN
    RETURN @return
END

BEGIN TRAN TRAN_bibitReversePurchase

          INSERT INTO AccountTransaction 
        (   xactionId,
            userId,
            creditTypeId,
            xactionTypeId,
            contentId,
            credits,
            balance,
            dateCreated
        )
        VALUES 
        (   @xactionId,
            @userId,
            @creditTypeId,
            @xactionTypeId,
            @contentId,
            - @credits,
            @balance,
            @dateNow
        )

        IF @@error = 0
	   BEGIN
             INSERT INTO Purchase 
            (   xactionId,
                purchaseTypeId,
                billingLocationId,
                purchaseOfferDetailId,
                currencyId,
                cost,
                costUSD,
                tax,
                taxUSD,
                userId,
                dateCreated,
                creditCardId,
                cardProcessor,
                xactionTypeId,
                refXactionId
              )
              VALUES (
                @xactionId,
                @purchaseTypeId,
                @billingLocationId,
                @purchaseOfferDetailId,
                @currencyId,
                -@cost,
                -@costUSD,
                -@tax,
                -@taxUSD,
                @userId,
                @dateNow,
                @creditCardId,
                @cardProcessor,
                @xactionTypeId,
                @refXactionId
              )

            IF @@error = 0
                 BEGIN
                   IF EXISTS (SELECT 1 FROM CreditBalance WHERE userId = @userId AND creditTypeId = @creditTypeId)
                      BEGIN
                            UPDATE CreditBalance 
                            SET credits = credits - @credits,
                                dateModified = @dateNow
                            WHERE userId = @userId AND creditTypeId = @creditTypeId
                            
                            IF @@error = 0
                                BEGIN
                                    COMMIT TRAN TRAN_bibitReversePurchase
                                    RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_bibitReversePurchase
                                	RETURN 99
                                END
                      END
                   ELSE
                      BEGIN
                            INSERT INTO CreditBalance
                            (   userId,
                                creditTypeId,
                                credits,
                                dateExpiry,
                                dateModified,
                                dateCreated
                            )
                            VALUES 
                            (   @userId,
                                @creditTypeId,
                                -@credits,
                                '20521231',
                                @dateNow,
                                @dateNow
                            )

                            IF @@error = 0
                                BEGIN
                                	COMMIT TRAN TRAN_bibitReversePurchase
                                	RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_bibitReversePurchase
                                	RETURN 98
                                END

                    END
                END
	   ELSE
		BEGIN
                	ROLLBACK TRAN TRAN_bibitReversePurchase
			RETURN 97
		END
          END
    ELSE
		BEGIN
			ROLLBACK TRAN TRAN_bibitReversePurchase
			RETURN 96
		END
go
IF OBJECT_ID('dbo.wsp_bibitReversePurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_bibitReversePurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_bibitReversePurchase >>>'
go
GRANT EXECUTE ON dbo.wsp_bibitReversePurchase TO web
go


