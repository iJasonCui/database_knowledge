IF OBJECT_ID('dbo.wsp_purchaseBundle') IS NOT NULL
    BEGIN
        DROP PROCEDURE dbo.wsp_purchaseBundle
        IF OBJECT_ID('dbo.wsp_purchaseBundle') IS NOT NULL
            PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_purchaseBundle >>>'
        ELSE
            PRINT '<<< DROPPED PROCEDURE dbo.wsp_purchaseBundle >>>'
    END
go
/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         November 2005
**   Description:  Purchase service bundle for user
**                 Note: cartPurchaseBundle is in this format: '{cartItem1} {cartItem2} {cartItem3} {etc}'
**                 Where cartItem has the form '{offerDetailId, contentId, credits}'
**
**
** REVISION(S):
**   Author:  Mike Stairs
**   Date:    Feb 27, 2006
**   Description: also update dateLastUsed column in CreditCard table
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_purchaseBundle
 @userId                    NUMERIC(12,0)
,@purchaseXactionId         NUMERIC(12,0)
,@xactionTypeId             TINYINT
,@credits                   SMALLINT
,@cost                      NUMERIC(10,2)
,@tax                       NUMERIC(10,2)
,@costUSD                   NUMERIC(5,2)
,@taxUSD                    NUMERIC(5,2)
,@creditTypeId              TINYINT
,@userType                  CHAR(1)
,@cartPurchaseBundle        VARCHAR(256)
,@dateExpiry                DATETIME
,@purchaseTypeId            TINYINT
,@billingLocationId         SMALLINT
,@currencyId                TINYINT
,@creditCardId              INT
,@adminUserId               INT
,@paymentNumber             VARCHAR(40)
,@cardProcessor             CHAR(1)
AS

DECLARE
 @return                    INT
,@dateNow                   DATETIME
,@balance                   INT
,@cartPurchaseItem          VARCHAR(256)
,@cartItemXactionId         NUMERIC(12,0)
,@cartItemOfferDetailId     SMALLINT
,@cartItemContentId         SMALLINT
,@cartItemCredits           SMALLINT
,@cartItemCreditTypeId      SMALLINT
,@cartItemCost              NUMERIC(10,2)
,@cartItemCostUSD           NUMERIC(5,2)
,@idxItemOpen               INT
,@idxItemClose              INT
,@idxItemDelim              INT

IF @dateExpiry IS NULL
    BEGIN
        SELECT @dateExpiry = '20521231'
    END

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF @purchaseXactionId <= 0
    BEGIN
        EXEC @return = dbo.wsp_XactionId @purchaseXactionId OUTPUT
    END

IF @return != 0
    BEGIN
        RETURN @return
    END

EXEC @return = dbo.wsp_getTotalCredits @userId, @balance OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

SELECT @balance = @balance + @credits

BEGIN TRAN TRAN_purchaseBundle

    -- find the beginning and end brackets for a cartPurchaseItem
    SELECT @idxItemOpen = CHARINDEX('{', @cartPurchaseBundle)
    SELECT @idxItemClose = CHARINDEX('}', @cartPurchaseBundle)
    
    -- begin loop: to extract offer details from string
    WHILE (@idxItemOpen > 0 AND @idxItemClose > 0)
        BEGIN
            -- extract the offerDetailId from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseBundle, @idxItemOpen+1, @idxItemClose-2)))
            SELECT @idxItemDelim = CHARINDEX(',', @cartPurchaseItem)
            SELECT @cartItemOfferDetailId = CONVERT(SMALLINT, SUBSTRING(@cartPurchaseItem, 1, @idxItemDelim-1))
            
            -- extract the contentId from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseItem, @idxItemDelim+1, CHAR_LENGTH(@cartPurchaseItem))))
            SELECT @idxItemDelim = CHARINDEX(',', @cartPurchaseItem)
            SELECT @cartItemContentId = CONVERT(SMALLINT, SUBSTRING(@cartPurchaseItem, 1, @idxItemDelim-1))
            
            -- extract the number of credits from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseItem, @idxItemDelim+1, CHAR_LENGTH(@cartPurchaseItem))))
            SELECT @idxItemDelim = CHARINDEX(',', @cartPurchaseItem)
            SELECT @cartItemCredits = CONVERT(SMALLINT, SUBSTRING(@cartPurchaseItem, 1, @idxItemDelim-1))
            
            -- extract the creditTypeId from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseItem, @idxItemDelim+1, CHAR_LENGTH(@cartPurchaseItem))))
            SELECT @idxItemDelim = CHARINDEX(',', @cartPurchaseItem)
            SELECT @cartItemCreditTypeId = CONVERT(SMALLINT, SUBSTRING(@cartPurchaseItem, 1, @idxItemDelim-1))
            
            -- extract the cost from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseItem, @idxItemDelim+1, CHAR_LENGTH(@cartPurchaseItem))))
            SELECT @idxItemDelim = CHARINDEX(',', @cartPurchaseItem)
            SELECT @cartItemCost = CONVERT(NUMERIC(10,2), SUBSTRING(@cartPurchaseItem, 1, @idxItemDelim-1))
            
            -- extract the cost USD from cartPurchaseItem
            SELECT @cartPurchaseItem = LTRIM(RTRIM(SUBSTRING(@cartPurchaseItem, @idxItemDelim+1, CHAR_LENGTH(@cartPurchaseItem))))
            SELECT @cartItemCostUSD = CONVERT(NUMERIC(5,2), @cartPurchaseItem)
            
            -- extract the next cartPurchaseItem from the bundle
            SELECT @cartPurchaseBundle = LTRIM(RTRIM(SUBSTRING(@cartPurchaseBundle, @idxItemClose+1, CHAR_LENGTH(@cartPurchaseBundle))))
            SELECT @idxItemOpen = CHARINDEX('{', @cartPurchaseBundle)
            SELECT @idxItemClose = CHARINDEX('}', @cartPurchaseBundle)

            -- generate a new xactionId for each card item
            EXEC @return = dbo.wsp_XactionId @cartItemXactionId OUTPUT
            IF @return != 0
                BEGIN
                    ROLLBACK TRAN TRAN_purchaseBundle
                    RETURN @return
                END

            -- update shopping cart
            INSERT INTO ShoppingCartTransaction
            (
                 xactionId
                ,purchaseXactionId
                ,purchaseOfferDetailId
                ,cost
                ,costUSD
                ,dateCreated
            )
            VALUES
            (
                 @cartItemXactionId
                ,@purchaseXactionId
                ,@cartItemOfferDetailId
                ,@cartItemCost
                ,@cartItemCostUSD
                ,@dateNow
            )
            
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_purchaseBundle
                    RETURN 98
                END

            -- update account transaction
            INSERT INTO AccountTransaction 
            (
                 xactionId
                ,userId
                ,xactionTypeId
                ,creditTypeId
                ,contentId
                ,credits
                ,balance
                ,userType
                ,dateCreated
            )
            VALUES 
            (
                 @cartItemXactionId
                ,@userId
                ,@xactionTypeId
                ,@cartItemCreditTypeId
                ,@cartItemContentId
                ,@cartItemCredits
                ,@balance
                ,@userType
                ,@dateNow
            )
    
            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_purchaseBundle
                    RETURN 98
                END
        END
    -- end loop

    -- update admin account transaction
    IF @adminUserId > 0
        BEGIN
            INSERT INTO AdminAccountTransaction
            (
                 xactionId
                ,adminUserId
                ,userId
                ,dateCreated
            )
            VALUES
            (
                 @purchaseXactionId
                ,@adminUserId
                ,@userId
                ,@dateNow
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_purchaseBundle
                    RETURN 98
                END
        END

    -- update purchase    
    INSERT INTO Purchase 
    (
         xactionId
        ,purchaseTypeId
        ,billingLocationId
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
    )
    VALUES
    (
         @purchaseXactionId
        ,@purchaseTypeId
        ,@billingLocationId
        ,@currencyId
        ,@cost
        ,@costUSD
        ,@tax
        ,@taxUSD
        ,@userId
        ,@dateNow
        ,@creditCardId
        ,@cardProcessor
        ,@paymentNumber
        ,@xactionTypeId
    )
            
    IF @@error != 0
       BEGIN
         ROLLBACK TRAN TRAN_purchaseBundle
         RETURN 98
       END

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

                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_purchaseBundle
                            RETURN 98
                        END
                    ELSE
                        BEGIN
                            COMMIT TRAN TRAN_purchaseBundle
                            SELECT @purchaseXactionId
                            RETURN 0
                        END
                END
            ELSE
                BEGIN
                    INSERT INTO CreditBalance
                    (
                         userId
                        ,creditTypeId
                        ,credits
                        ,dateExpiry
                        ,dateModified
                        ,dateCreated
                    )
                    VALUES 
                    (
                         @userId
                        ,@creditTypeId
                        ,@credits
                        ,@dateExpiry
                        ,@dateNow
                        ,@dateNow
                    )
                    
                    IF @@error != 0
                        BEGIN
                            ROLLBACK TRAN TRAN_purchaseBundle
                            RETURN 98
                        END
                    ELSE
                        BEGIN
                            COMMIT TRAN TRAN_purchaseBundle
                            SELECT @purchaseXactionId
                            RETURN 0
                        END
                END
        END
    ELSE
        BEGIN
            IF @@error != 0  -- check error level and credit total > 0 because declined purchases don't update creditBalance
                BEGIN
                    ROLLBACK TRAN TRAN_purchaseBundle
                    RETURN 98
                END
            ELSE
                BEGIN
                    COMMIT TRAN TRAN_purchaseBundle
                    SELECT @purchaseXactionId
                    RETURN 0
                END
        END
go

IF OBJECT_ID('dbo.wsp_purchaseBundle') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_purchaseBundle >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_purchaseBundle >>>'
go

GRANT EXECUTE ON dbo.wsp_purchaseBundle TO web
go
