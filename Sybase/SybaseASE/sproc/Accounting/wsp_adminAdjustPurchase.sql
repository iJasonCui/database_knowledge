IF OBJECT_ID('dbo.wsp_adminAdjustPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_adminAdjustPurchase
    IF OBJECT_ID('dbo.wsp_adminAdjustPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_adminAdjustPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_adminAdjustPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  June 13, 2005
**   Description:  adjust  purchase for user
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: July 7, 2005
**   Description: pass in card processor
**
**   Author: Andy Tran
**   Date: May 5, 2010
**   Description: add location tax IDs
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_adminAdjustPurchase
@userId NUMERIC(12,0),
@xactionId NUMERIC(12,0),
@refXactionId NUMERIC(12,0),
@contentId SMALLINT,
@xactionTypeId TINYINT,
@cardProcessor CHAR(1),
@adminUserId INT,
@adminNote VARCHAR(255)
AS

DECLARE @return 		INT
,@creditTypeId                  TINYINT
,@dateNow 			DATETIME
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

SELECT @cost = cost,
       @costUSD = costUSD,
       @tax = tax,
       @taxUSD = taxUSD,
       @creditTypeId = creditTypeId,
       @creditCardId = creditCardId,
       @currencyId = currencyId,
       @purchaseOfferDetailId = purchaseOfferDetailId,
       @billingLocationId = billingLocationId,
       @purchaseTypeId = purchaseTypeId,
       @taxCountryId = taxCountryId,
       @taxJurisdictionId = taxJurisdictionId
     FROM AccountTransaction,Purchase 
     WHERE AccountTransaction.xactionId=@refXactionId AND
       AccountTransaction.xactionId=Purchase.xactionId

BEGIN TRAN TRAN_adminAdjustPurchase

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
            0,
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
                taxCountryId,
                taxJurisdictionId
              )
              VALUES (
                @xactionId,
                @purchaseTypeId,
                @billingLocationId,
                @purchaseOfferDetailId,
                @currencyId,
                0,
                0,
                0,
                0,
                @userId,
                @dateNow,
                @creditCardId,
                @cardProcessor,
                @xactionTypeId,
                @refXactionId,
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
                   COMMIT TRAN TRAN_adminAdjustPurchase
                   RETURN 0
                END
             ELSE
                BEGIN
                   ROLLBACK TRAN TRAN_adminAdjustPurchase
                   RETURN 98
                END
          END
        ELSE
		BEGIN
			ROLLBACK TRAN TRAN_adminAdjustPurchase
			RETURN 97
		END
     END
    ELSE
		BEGIN
			ROLLBACK TRAN TRAN_adminAdjustPurchase
			RETURN 96
		END
go
IF OBJECT_ID('dbo.wsp_adminAdjustPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_adminAdjustPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_adminAdjustPurchase >>>'
go
GRANT EXECUTE ON dbo.wsp_adminAdjustPurchase TO web
go


