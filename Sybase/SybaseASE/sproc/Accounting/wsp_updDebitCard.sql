IF OBJECT_ID('dbo.wsp_updDebitCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updDebitCard
    IF OBJECT_ID('dbo.wsp_updDebitCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updDebitCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updDebitCard >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         June 29, 2004
**   Description:  Update debit card. Create one if it does not exist.
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Added realCardTypeId.
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updDebitCard
     @creditCardId      INT
    ,@userId            NUMERIC(12,0)
    ,@cardTypeId        SMALLINT
    ,@cardNum           VARCHAR(64)
    ,@encodedCardNum    VARCHAR(64)
    ,@partialCardNum    CHAR(8)
    ,@cardExpiry        CHAR(4)
    ,@cardNickname      VARCHAR(40)
    ,@nameOnCard        VARCHAR(40)
    ,@address           VARCHAR(80)
    ,@city              VARCHAR(32)
    ,@country           VARCHAR(24)
    ,@countryArea       VARCHAR(32)
    ,@zipCode           VARCHAR(10)
    ,@cvv               CHAR(3)
    ,@status            CHAR(1)
    ,@realCardTypeId    SMALLINT
    ,@issueNumber       CHAR(2)
    ,@cardStartDate     CHAR(4)
AS

DECLARE
 @return      INT
,@GetDateGMT  DATETIME

SELECT @nameOnCard = UPPER(@nameOnCard)

EXEC @return = wsp_GetDateGMT @GetDateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM CreditCard WHERE creditCardId = @creditCardId)
    BEGIN
        BEGIN TRAN TRAN_updDebitCard
            UPDATE CreditCard
               SET cardTypeId = @cardTypeId
                  ,cardExpiry = @cardExpiry
                  ,cardNickname = @cardNickname
                  ,nameOnCard = @nameOnCard
                  ,address = @address
                  ,city = @city
                  ,country = @country
                  ,countryArea = @countryArea
                  ,zipCode = @zipCode
                  ,status = @status
                  ,dateModified = @GetDateGMT
             WHERE creditCardId = @creditCardId

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updDebitCard
                    RETURN 99
                END

            UPDATE DebitCard
               SET issueNumber = @issueNumber
                  ,cardStartDate = @cardStartDate
                  ,dateModified = @GetDateGMT
             WHERE cardId = @creditCardId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updDebitCard
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updDebitCard
                    RETURN 98
                END
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_updDebitCard
            INSERT CreditCard (
                 creditCardId
                ,userId
                ,cardTypeId
                ,cardNum
                ,encodedCardNum
                ,partialCardNum
                ,cardExpiry
                ,cardNickname
                ,nameOnCard
                ,address
                ,city
                ,country
                ,countryArea
                ,zipCode
                ,cvv
                ,status
                ,dateModified
                ,dateCreated
                ,realCardTypeId
            )
            VALUES (
                 @creditCardId
                ,@userId
                ,@cardTypeId
                ,@cardNum
                ,@encodedCardNum
                ,@partialCardNum
                ,@cardExpiry
                ,@cardNickname
                ,@nameOnCard
                ,@address
                ,@city
                ,@country
                ,@countryArea
                ,@zipCode
                ,@cvv
                ,@status
                ,@GetDateGMT
                ,@GetDateGMT
                ,@realCardTypeId
            )

            IF @@error != 0
                BEGIN
                    ROLLBACK TRAN TRAN_updDebitCard
                    RETURN 97
                END

            INSERT DebitCard (
                 cardId
                ,userId
                ,issueNumber
                ,cardStartDate
                ,dateModified
                ,dateCreated
            )
            VALUES (
                 @creditCardId
                ,@userId
                ,@issueNumber
                ,@cardStartDate
                ,@GetDateGMT
                ,@GetDateGMT
            )

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updDebitCard
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updDebitCard
                    RETURN 96
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updDebitCard TO web
go

IF OBJECT_ID('dbo.wsp_updDebitCard') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updDebitCard >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updDebitCard >>>'
go

EXEC sp_procxmode 'dbo.wsp_updDebitCard','unchained'
go
