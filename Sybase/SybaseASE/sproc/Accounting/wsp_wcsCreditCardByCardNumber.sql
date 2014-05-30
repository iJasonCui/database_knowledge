IF OBJECT_ID('dbo.wsp_wcsCreditCardByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsCreditCardByCardNumber
    IF OBJECT_ID('dbo.wsp_wcsCreditCardByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsCreditCardByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsCreditCardByCardNumber >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsCreditCardByCardNumber
 @rowcount   INT
,@encodedCardNum VARCHAR(64)
AS

BEGIN TRAN TRAN_wcsCreditCardByCardNumber
    SET ROWCOUNT @rowcount
    IF PATINDEX('%[^0-9]%', @encodedCardNum) = 0
    BEGIN
        SELECT userId
              ,replicate('*',12) + right(rtrim(partialCardNum),4) as cardNumber
              ,nameOnCard
              ,'N/A' as gender
              ,productId
          FROM dbo.CreditCard
         WHERE encodedCardId = CONVERT(INT, @encodedCardNum)
        ORDER BY userId DESC
    END
    ELSE
    BEGIN
        SELECT userId
              ,replicate('*',12) + right(rtrim(partialCardNum),4) as cardNumber
              ,nameOnCard
              ,'N/A' as gender
              ,productId
          FROM dbo.CreditCard
         WHERE encodedCardNum = @encodedCardNum
        ORDER BY userId DESC
    END

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_wcsCreditCardByCardNumber
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wcsCreditCardByCardNumber
            RETURN 99
        END
go
GRANT EXECUTE ON dbo.wsp_wcsCreditCardByCardNumber TO web
go
IF OBJECT_ID('dbo.wsp_wcsCreditCardByCardNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsCreditCardByCardNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsCreditCardByCardNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsCreditCardByCardNumber','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsCreditCardByCardNumber TO web
go
