IF OBJECT_ID('dbo.wsp_purchaseSubscription2') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_purchaseSubscription2
    IF OBJECT_ID('dbo.wsp_purchaseSubscription2') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_purchaseSubscription2 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_purchaseSubscription2 >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 26, 2004
**   Description:  purchase subscription for user
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Jan 12, 2006
**   Description: added durationUnits
**
**   Author:  Mike Stairs
**   Date:    Feb 27, 2006
**   Description: also update dateLastUsed column in CreditCard table
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_purchaseSubscription2
@userId NUMERIC(12,0),
@xactionId INT,
@xactionTypeId TINYINT,
@dateNow DATETIME,
@cost    numeric(10,2),
@tax     numeric(10,2),
@costUSD numeric (5,2),
@taxUSD  numeric (5,2),
@offerDetailId SMALLINT,
@contentId     SMALLINT,
@subscriptionTypeId SMALLINT,
@purchaseTypeId TINYINT,
@billingLocationId SMALLINT,
@currencyId TINYINT,
@creditCardId INT,
@adminUserId INT,
@paymentNumber VARCHAR(40),
@cardProcessor CHAR(1),
@duration INT,
@userTrans BIT,
@durationUnits CHAR(1),
@taxCountryId SMALLINT,
@taxJurisdictionId INT

AS

DECLARE @return 		INT
,@dateNowGMT                       DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT



IF @xactionId < 0
        BEGIN
          EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT

           IF @return != 0
	     BEGIN
		RETURN @return
	     END
	END


BEGIN TRAN TRAN_purchaseSubscription2

     IF @adminUserId > 0
        BEGIN
           INSERT INTO AdminAccountTransaction 
		   (xactionId, adminUserId, userId, dateCreated) 
		   VALUES (@xactionId, @adminUserId, @userId, @dateNowGMT)

           IF @@error > 0
	      BEGIN
                 ROLLBACK TRAN TRAN_purchaseSubscription2
                 RETURN 98
              END
        END
        
        INSERT INTO SubscriptionTransaction 
        (   xactionId,
            userId,
            cardId,
            xactionTypeId,
            contentId,
            subscriptionTypeId,
            dateCreated,
            duration,
            userTrans,
            durationUnits
        )
        VALUES 
        (   @xactionId,
            @userId,
            @creditCardId,
            @xactionTypeId,
            @contentId,
            @subscriptionTypeId,
            @dateNowGMT,
            @duration,
            @userTrans,
            @durationUnits
        )
        
        IF @@error > 0
	  BEGIN
             ROLLBACK TRAN TRAN_purchaseSubscription2
             RETURN 97
          END

        INSERT INTO Purchase 
            (   xactionId,
                purchaseTypeId,
                billingLocationId,
                subscriptionOfferDetailId,
                currencyId,
                cost,
                costUSD,
                tax,
                taxUSD,
                userId,
                dateCreated,
                creditCardId,
                cardProcessor,
                paymentNumber,
                xactionTypeId,
				taxCountryId,
				taxJurisdictionId
              )
           VALUES (
                @xactionId,
                @purchaseTypeId,
                @billingLocationId,
                @offerDetailId,
                @currencyId,
                @cost,
                @costUSD,
                @tax,
                @taxUSD,
                @userId,
                @dateNowGMT,
                @creditCardId,
                @cardProcessor,
                @paymentNumber,
                @xactionTypeId,
				@taxCountryId,
				@taxJurisdictionId
              )

         -- update CreditCard dateLastUsed column
         IF @creditCardId > 0
         BEGIN
            UPDATE CreditCard SET dateLastUsed = @dateNow WHERE creditCardId = @creditCardId
            IF @@error != 0
            BEGIN
              ROLLBACK TRAN TRAN_purchaseBundle
              RETURN 98
           END
         END

         IF @@error = 0
                 BEGIN
                    COMMIT TRAN TRAN_purchaseSubscription2
                    SELECT @xactionId
                    RETURN 0
                 END
         ELSE
                 BEGIN
                    ROLLBACK TRAN TRAN_purchaseSubscription2
                    RETURN 96
                 END
go
IF OBJECT_ID('dbo.wsp_purchaseSubscription2') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_purchaseSubscription2 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_purchaseSubscription2 >>>'
go
GRANT EXECUTE ON dbo.wsp_purchaseSubscription2 TO web
go

