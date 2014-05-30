IF OBJECT_ID('dbo.wsp_purchaseCredit') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_purchaseCredit
    IF OBJECT_ID('dbo.wsp_purchaseCredit') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_purchaseCredit >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_purchaseCredit >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 10, 2003
**   Description:  purchase credits for user
**
** REVISION(S):
**   Author:  Mike Stairs
**   Date:    Feb 27, 2006
**   Description: also update dateLastUsed column in CreditCard table
**
**   Author: Andy Tran
**   Date: May 5, 2010
**   Description: add location tax IDs
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_purchaseCredit
@userId NUMERIC(12,0),
@xactionId INT,
@xactionTypeId TINYINT,
@credits SMALLINT,
@cost    numeric(10,2),
@tax     numeric(10,2),
@costUSD numeric (5,2),
@taxUSD  numeric (5,2),
@creditTypeId TINYINT,
@userType CHAR(1),
@offerDetailId SMALLINT,
@dateExpiry DATETIME,
@contentId SMALLINT,
@purchaseTypeId TINYINT,
@billingLocationId SMALLINT,
@currencyId TINYINT,
@creditCardId INT,
@adminUserId INT,
@paymentNumber VARCHAR(40),
@cardProcessor CHAR(1),
@taxCountryId SMALLINT,
@taxJurisdictionId INT

AS

DECLARE @return 		INT
,@dateNow 			DATETIME
,@balance                       INT

IF @dateExpiry IS NULL
        BEGIN
               SELECT @dateExpiry = '20521231'
        END

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

IF @xactionId < 0
        BEGIN
          EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT
	END

IF @return != 0
	BEGIN
		RETURN @return
	END

EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT

IF @return != 0
	BEGIN
		RETURN @return
	END

SELECT @balance = @balance + @credits


BEGIN TRAN TRAN_purchaseCredit

     IF @adminUserId > 0
        BEGIN
           INSERT INTO AdminAccountTransaction 
		   (xactionId, adminUserId, userId, dateCreated) 
		   VALUES (@xactionId, @adminUserId, @userId, @dateNow)

           IF @@error > 0
	       	  BEGIN
                 ROLLBACK TRAN TRAN_purchaseCredit
                 RETURN 98
              END
        END
        
        INSERT INTO AccountTransaction 
        (   xactionId,
            userId,
            xactionTypeId,
            creditTypeId,
            contentId,
            credits,
            balance,
            userType,
            dateCreated
        )
        VALUES 
        (   @xactionId,
            @userId,
            @xactionTypeId,
            @creditTypeId,
            @contentId,
            @credits,
            @balance,
            @userType,
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
                @dateNow,
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


            -- check error level and credit total > 0 because declined purchases don't update creditBalance
            IF @@error = 0 AND @credits > 0
                 BEGIN
                   IF EXISTS (SELECT 1 FROM CreditBalance WHERE userId = @userId AND creditTypeId = @creditTypeId)
                      BEGIN
                            UPDATE CreditBalance 
                            SET credits = credits + @credits,
                                dateModified = @dateNow,
                                dateExpiry = @dateExpiry
                            WHERE userId = @userId AND creditTypeId = @creditTypeId

                            IF @@error = 0
                                BEGIN
                                    COMMIT TRAN TRAN_purchaseCredit
                                    SELECT @xactionId
                                    RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_purchaseCredit
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
                                @credits,
                                @dateExpiry,
                                @dateNow,
                                @dateNow
                            )

                            IF @@error = 0
                                BEGIN
                                	COMMIT TRAN TRAN_purchaseCredit
                                        SELECT @xactionId
                                	RETURN 0
                                END
                            ELSE
                                BEGIN
                                 	ROLLBACK TRAN TRAN_purchaseCredit
                                	RETURN 98
                                END
                        END
                    END

	   ELSE
             BEGIN
              IF @@error > 0  -- check error level and credit total > 0 because declined purchases don't update creditBalance
		BEGIN
                	ROLLBACK TRAN TRAN_purchaseCredit
			RETURN 98
		END
              ELSE 
                                BEGIN
                                	COMMIT TRAN TRAN_purchaseCredit
                                        SELECT @xactionId
                                	RETURN 0
                                END
              END
          END
        ELSE
		BEGIN
			ROLLBACK TRAN TRAN_purchaseCredit
			RETURN 97
		END
go
IF OBJECT_ID('dbo.wsp_purchaseCredit') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_purchaseCredit >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_purchaseCredit >>>'
go
GRANT EXECUTE ON dbo.wsp_purchaseCredit TO web
go

