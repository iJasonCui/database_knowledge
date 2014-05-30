IF OBJECT_ID('dbo.wsp_processAutomatedChargebac2') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_processAutomatedChargebac2
    IF OBJECT_ID('dbo.wsp_processAutomatedChargebac2') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_processAutomatedChargebac2 >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_processAutomatedChargebac2 >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 29, 2006
**   Description:  attempt to chargeback purchase if it exists. First check if
**                 refXactionId exists, else check by cardNumber/date
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_processAutomatedChargebac2
@refXactionId NUMERIC(12,0),
@encodedCardNumber VARCHAR(64),
@cost NUMERIC (10,2),
@fromDateCreated DATETIME,
@toDateCreated DATETIME
AS
DECLARE @return                 INT
,@userId                        NUMERIC(12,0)
,@credits                       SMALLINT
,@creditTypeId                  TINYINT
,@dateNow                       DATETIME
,@balance                       INT
,@costUSD                       NUMERIC (5,2)
,@tax                           NUMERIC (10,2)
,@taxUSD                        NUMERIC (5,2)
,@currencyId                    TINYINT
,@purchaseOfferDetailId         SMALLINT
,@purchaseTypeId                TINYINT
,@billingLocationId             SMALLINT
,@creditCardId                  INT
,@xactionId                     NUMERIC(12,0)
,@contentId                     SMALLINT
,@found                         INT
,@subscriptionOfferDetailId     SMALLINT
,@xactionTypeId                 TINYINT
,@subscriptionTypeId            SMALLINT
,@duration                      SMALLINT
,@durationUnits                 CHAR(1)
,@type                          CHAR(1)
,@partialCardNumber             CHAR(8)
,@cardStatus                    CHAR(1)
,@cvvResponseCode               CHAR(1)
,@avsResponseCode               CHAR(1)
,@taxCountryId                  SMALLINT
,@taxJurisdictionId             INT

SELECT @creditCardId = -1
SELECT @found = -1
SELECT @xactionTypeId = 39 -- automated chargeback xactionTypeId
SELECT @contentId = 54 -- Admin purchase reversal - Adjustment
-- first see if row exists by refXactionId
IF EXISTS (SELECT 1 FROM Purchase WHERE xactionId = @refXactionId AND @refXactionId > 0)
BEGIN
  SELECT @found = 1
  SELECT @creditCardId = creditCardId,@userId=userId FROM Purchase WHERE xactionId = @refXactionId
  SELECT @partialCardNumber=partialCardNum, @cardStatus=status FROM CreditCard WHERE creditCardId=@creditCardId
END
-- else check by cardnumber and date
ELSE
BEGIN
    -- create temporary table with list of creditCardIds for this encodedCardNum for efficiency sake
    SELECT creditCardId INTO #processAutomatedChargebac2 FROM CreditCard WHERE encodedCardNum =  @encodedCardNumber

    -- return first matching purchase for this card that doesn't already have a charge associated with it for this day
    SET ROWCOUNT 1
    SELECT @refXactionId=xactionId, @creditCardId = creditCardId, @userId=userId FROM Purchase WHERE
               creditCardId IN (SELECT creditCardId FROM #processAutomatedChargebac2) AND
               cost + tax = @cost AND
               dateCreated < @toDateCreated AND
               dateCreated >= @fromDateCreated AND
               xactionId NOT IN (
                  SELECT ISNULL(refXactionId,-9999) FROM Purchase WHERE
                  cost + tax = -@cost AND
                  xactionTypeId IN (39,8) AND
                  dateCreated >= @fromDateCreated AND
                  creditCardId IN (SELECT creditCardId FROM #processAutomatedChargebac2))
    SET ROWCOUNT 0

    IF @creditCardId > 0 
    BEGIN
      SELECT @found = 1
      SELECT @partialCardNumber=partialCardNum, @cardStatus=status FROM CreditCard WHERE creditCardId=@creditCardId
    END
END
-- record not found just return
IF @found != 1
BEGIN
   RETURN 0
END

SELECT @cvvResponseCode = securityResponseCode, @avsResponseCode = avsResponseCode FROM PaymentechResponse WHERE xactionId = @refXactionId

IF EXISTS (SELECT 1 FROM SubscriptionTransaction WHERE xactionId=@refXactionId)
   SELECT @type = 'S'
ELSE
   SELECT @type = 'C'


EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END


IF (@type = 'C')
BEGIN

  EXEC  @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT

  IF @return != 0
  BEGIN
     RETURN @return
  END

  SELECT @cost=cost,
       @costUSD=costUSD,
       @tax=tax,
       @taxUSD=taxUSD,
       @credits = credits,
       @creditTypeId = creditTypeId,
       @creditCardId = creditCardId,
       @currencyId=currencyId,
       @purchaseOfferDetailId=purchaseOfferDetailId,
       @billingLocationId=billingLocationId,
       @purchaseTypeId=purchaseTypeId,
       @taxCountryId=taxCountryId,
	   @taxJurisdictionId=taxJurisdictionId
     FROM AccountTransaction,Purchase 
     WHERE AccountTransaction.xactionId=@refXactionId AND
       AccountTransaction.xactionId=Purchase.xactionId
-----------------------
     IF @@rowcount = 0 
     BEGIN
       SELECT @userId, @creditCardId, @cardStatus, @partialCardNumber,@xactionId,@cvvResponseCode,@avsResponseCode,@refXactionId    
       RETURN 0
     END 
------------------
  SELECT @balance = @balance - @credits

  EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT	
  IF @return != 0
  BEGIN
    RETURN @return
  END

  BEGIN TRAN TRAN_processAutomatedChargebk

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
            "AUTOMATED CHARGEBACK",
            @dateNow
        )

        IF @@error != 0
        BEGIN
           ROLLBACK TRAN TRAN_processAutomatedChargebk
           RETURN 99
        END

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
                -@cost,
                -@costUSD,
                -@tax,
                -@taxUSD,
                @userId,
                @dateNow,
                @creditCardId,
                null,
                @xactionTypeId,
                @refXactionId,
				@taxCountryId,
				@taxJurisdictionId
              )

       IF @@error != 0
       BEGIN
           ROLLBACK TRAN TRAN_processAutomatedChargebk
           RETURN 98
       END

       INSERT INTO AdminAccountTransaction 
            (   xactionId,
                adminUserId,
		userId,
		dateCreated
            )
      VALUES
            (
                @xactionId,
                9999,
		@userId,
		@dateNow
             )

       IF @@error != 0
       BEGIN
           ROLLBACK TRAN TRAN_processAutomatedChargebk
           RETURN 97
       END

       IF EXISTS (SELECT 1 FROM CreditBalance WHERE userId = @userId AND creditTypeId = @creditTypeId)
       BEGIN
            UPDATE CreditBalance 
            SET credits = credits - @credits,
                dateModified = @dateNow
            WHERE userId = @userId AND creditTypeId = @creditTypeId
                            
            IF @@error = 0
            BEGIN
               COMMIT TRAN TRAN_processAutomatedChargebk
               SELECT @userId, @creditCardId, @cardStatus, @partialCardNumber,@xactionId,@cvvResponseCode,@avsResponseCode,@refXactionId
               RETURN 0
            END
            ELSE
            BEGIN
              ROLLBACK TRAN TRAN_processAutomatedChargebk
              RETURN 96
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
            COMMIT TRAN TRAN_processAutomatedChargebk
            SELECT @userId, @creditCardId, @cardStatus, @partialCardNumber,@xactionId,@cvvResponseCode,@avsResponseCode,@refXactionId
            RETURN 0
          END
          ELSE
          BEGIN
            ROLLBACK TRAN TRAN_processAutomatedChargebk
            RETURN 95
          END
       END
END
ELSE  -- process subscription chargeback
BEGIN
  SELECT @cost=cost,
       @costUSD=costUSD,
       @tax=tax,
       @taxUSD=taxUSD,
       @subscriptionTypeId = subscriptionTypeId,
       @creditCardId = creditCardId,
       @currencyId=currencyId,
       @duration=duration,
       @subscriptionOfferDetailId=Purchase.subscriptionOfferDetailId,
       @billingLocationId=billingLocationId,
       @purchaseTypeId=purchaseTypeId,
       @durationUnits=durationUnits,
       @taxCountryId=taxCountryId,
	   @taxJurisdictionId=taxJurisdictionId	   
     FROM SubscriptionTransaction,Purchase 
     WHERE SubscriptionTransaction.xactionId=@refXactionId AND
       SubscriptionTransaction.xactionId=Purchase.xactionId


  EXEC @return = dbo.wsp_XactionId @xactionId OUTPUT	
  IF @return != 0
   BEGIN
	 RETURN @return
   END

  BEGIN TRAN TRAN_adminReverseSubscrPurch

          INSERT INTO SubscriptionTransaction 
        (   xactionId,
            cardId,
            userId,
            subscriptionTypeId,
            duration,
            xactionTypeId,
            contentId,
            description,
            dateCreated,
            durationUnits
        )
        VALUES 
        (   @xactionId,
            @creditCardId,
            @userId,
            @subscriptionTypeId,
            @duration,
            @xactionTypeId,
            @contentId,
            "AUTOMATED CHARGEBACK",
            @dateNow,
            @durationUnits
        )

        IF @@error != 0
        BEGIN
           ROLLBACK TRAN TRAN_processAutomatedChargebk
           RETURN 89
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
                xactionTypeId,
                refXactionId,
				taxCountryId,
				taxJurisdictionId
              )
       VALUES (
                @xactionId,
                @purchaseTypeId,
                @billingLocationId,
                @subscriptionOfferDetailId,
                @currencyId,
                -@cost,
                -@costUSD,
                -@tax,
                -@taxUSD,
                @userId,
                @dateNow,
                @creditCardId,
                null,
                @xactionTypeId,
                @refXactionId,
				@taxCountryId,
				@taxJurisdictionId
              )

       IF @@error != 0
       BEGIN
           ROLLBACK TRAN TRAN_processAutomatedChargebk
           RETURN 88
       END

       INSERT INTO AdminAccountTransaction 
            (   xactionId,
                adminUserId,
		userId,
		dateCreated
            )
      VALUES
            (
                @xactionId,
                9999,
		@userId,
		@dateNow
             )

       IF @@error = 0
       BEGIN
          COMMIT TRAN TRAN_processAutomatedChargebk
          SELECT @userId, @creditCardId, @cardStatus, @partialCardNumber,@xactionId,@cvvResponseCode,@avsResponseCode,@refXactionId
          RETURN 0
       END
       ELSE
       BEGIN
          ROLLBACK TRAN TRAN_processAutomatedChargebk
          RETURN 87
       END
END
go
IF OBJECT_ID('dbo.wsp_processAutomatedChargebac2') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_processAutomatedChargebac2 >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_processAutomatedChargebac2 >>>'
go
GRANT EXECUTE ON dbo.wsp_processAutomatedChargebac2 TO web
go


