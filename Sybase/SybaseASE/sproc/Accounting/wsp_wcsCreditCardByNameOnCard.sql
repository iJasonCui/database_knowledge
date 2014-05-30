IF OBJECT_ID('dbo.wsp_wcsCreditCardByNameOnCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard
    IF OBJECT_ID('dbo.wsp_wcsCreditCardByNameOnCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard >>>'
END
go
CREATE PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard
 @rowcount   INT
,@nameOnCard VARCHAR(40)
AS
SELECT @nameOnCard = UPPER(@nameOnCard)

BEGIN TRAN TRAN_wcsCreditCardByNameOnCard
    SET rowcount @rowcount

    SELECT userId
          ,replicate('*',12) + right(rtrim(partialCardNum),4)
          ,nameOnCard
          ,'N/A' as gender
      FROM dbo.CreditCard
     WHERE nameOnCard LIKE @nameOnCard
    ORDER BY userId DESC

    IF @@error = 0
        BEGIN
            COMMIT TRAN TRAN_wcsCreditCardByNameOnCard
            RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wcsCreditCardByNameOnCard
            RETURN 99
        END
go
GRANT EXECUTE ON dbo.wsp_wcsCreditCardByNameOnCard TO web
go
IF OBJECT_ID('dbo.wsp_wcsCreditCardByNameOnCard') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_wcsCreditCardByNameOnCard >>>'
go
EXEC sp_procxmode 'dbo.wsp_wcsCreditCardByNameOnCard','unchained'
go
GRANT EXECUTE ON dbo.wsp_wcsCreditCardByNameOnCard TO web
go
