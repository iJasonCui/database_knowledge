IF OBJECT_ID('dbo.wsp_adminReversePurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminReversePurchase
    IF OBJECT_ID('dbo.wsp_adminReversePurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminReversePurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminReversePurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 9, 2003
**   Description:  reverses  purchase for user
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: July 7, 2005
**   Description: pass in card processor
**
**   Author: Andy Tran
**   Date: November 15, 2006
**   Description: pass in payment number
**
**   Author: Andy Tran
**   Date: May 5, 2010
**   Description: add location tax IDs
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminReversePurchase
@userId NUMERIC(12,0),
@xactionId NUMERIC(12,0),
@refXactionId NUMERIC(12,0),
@contentId SMALLINT,
@xactionTypeId TINYINT,
@cardProcessor CHAR(1),
@adminUserId INT,
@adminNote VARCHAR(255),
@paymentNumber VARCHAR(40)
AS

DECLARE @return 		INT
,@credits                       SMALLINT
,@creditTypeId                  TINYINT
,@dateNow                       DATETIME
,@balance                       INT
,@cost                          NUMERIC (10,2)
,@costUSD                       NUMERIC (5,2)
,@tax                           NUMERIC (10,2)
,@taxUSD                        NUMERIC (5,2)
,@currencyId                    TINYINT
,@purchaseOfferDetailId         SMALLINT
,@purchaseTypeId                TINYINT
,@billingLocationId             SMALLINT
,@creditCardId                  INT
,@taxCountryId                  SMALLINT
,@taxJurisdictionId             INT

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

SELECT @cost = p.cost,
       @costUSD = p.costUSD, 
       @tax = p.tax,
       @taxUSD = p.taxUSD,
       @credits = credits,
       @creditTypeId = creditTypeId,
       @creditCardId = creditCardId,
       @currencyId = currencyId,
       @purchaseOfferDetailId = CASE p.purchaseOfferDetailId WHEN null THEN pd.purchaseOfferDetailId ELSE p.purchaseOfferDetailId END,
       @billingLocationId = billingLocationId,
       @purchaseTypeId = purchaseTypeId,
       @taxCountryId = taxCountryId,
       @taxJurisdictionId = taxJurisdictionId
     FROM AccountTransaction,Purchase p, PurchaseCreditDetail pd 
     WHERE AccountTransaction.xactionId=@refXactionId AND
       AccountTransaction.xactionId=p.xactionId AND
       p.xactionId *= pd.xactionId

SELECT @balance = @balance - @credits

IF @xactionId = -1  -- if reversal not passed through card processor, generate new xactionId and set cardProcessor = null
  BEGIN 
     SELECT @cardProcessor = NULL
     EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT	
     IF @return != 0
	BEGIN
		RETURN @return
	END
   END

BEGIN TRAN TRAN_adminReversePurchase

          INSERT INTO AccountTransaction 
        (   xactionId,
            userId,
            creditTypeId,
            xactionTypeId,
            contentId,
            credits,
            balance,
            description,
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
            @adminNote,
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
                refXactionId,
                paymentNumber,
                taxCountryId,
                taxJurisdictionId
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
                @refXactionId,
                @paymentNumber,
                @taxCountryId,
                @taxJurisdictionId
              )
        IF @@error = 0
	   BEGIN
             INSERT INTO AdminAccountTransaction 
            (   xactionId,
                adminUserId,
				userId,
				dateCreated
            )
            VALUES
            (
                @xactionId,
                @adminUserId,
				@userId,
				@dateNow
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
                                    COMMIT TRAN TRAN_adminReversePurchase
                                    RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_adminReversePurchase
                                	RETURN 98
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
                                	COMMIT TRAN TRAN_adminReversePurchase
                                	RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_adminReversePurchase
                                	RETURN 98
                                END

                    END
                END
	   ELSE
		BEGIN
                	ROLLBACK TRAN TRAN_adminReversePurchase
			RETURN 98
		END
          END
        ELSE
		BEGIN
			ROLLBACK TRAN TRAN_adminReversePurchase
			RETURN 97
		END
     END
    ELSE
		BEGIN
			ROLLBACK TRAN TRAN_adminReversePurchase
			RETURN 96
		END
go
IF OBJECT_ID('dbo.wsp_adminReversePurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminReversePurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminReversePurchase >>>'
go
GRANT EXECUTE ON dbo.wsp_adminReversePurchase TO web
go


