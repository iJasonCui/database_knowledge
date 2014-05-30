IF OBJECT_ID('dbo.wsp_updCreditCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCreditCard
    IF OBJECT_ID('dbo.wsp_updCreditCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCreditCard >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Sep 9, 2003
**   Description:  Update credit card. Create one if it does not exist.
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Added realCardTypeId.
**
**   Author:       Mike Stairs
**   Date:         Aug 8, 2005
**   Description:  added cvvPassedFlag
**
**   Author:       Mike Stairs
**   Date:         Feb 27, 2006
**   Description:  added dateLastUsed
**
**   Author:       Mike Stairs
**   Date:         Feb 27, 2006
**   Description:  also update dateLastUsed column in CreditCard table
**
**   Author:       Mike Stairs
**   Date:         February 2008
**   Description:  always insert blank cardNum and cvv
**
**   Author:       Andy Tran
**   Date:         February 2011
**   Description:  added avsPassedFlag
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updCreditCard
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
    ,@cvvPassedFlag     CHAR(1)
    ,@productId         SMALLINT 
    ,@avsPassedFlag     CHAR(1)
AS

DECLARE
 @return      INT
,@dateNowGMT  DATETIME

SELECT @nameOnCard = UPPER(@nameOnCard)

EXEC @return = wsp_GetDateGMT @dateNowGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM CreditCard WHERE creditCardId = @creditCardId)
    BEGIN
        BEGIN TRAN TRAN_updCreditCard
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
                  ,dateModified = @dateNowGMT
                  ,cvvPassedFlag = @cvvPassedFlag
                  ,productId = @productId
                  ,dateLastUsed = @dateNowGMT
                  ,avsPassedFlag = @avsPassedFlag
             WHERE creditCardId = @creditCardId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updCreditCard
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updCreditCard
                    RETURN 99
                END
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_updCreditCard
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
                ,cvvPassedFlag
                ,productId
                ,dateLastUsed
                ,avsPassedFlag
            )
            VALUES (
                 @creditCardId
                ,@userId
                ,@cardTypeId
                ,'0'
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
                ,''
                ,@status
                ,@dateNowGMT
                ,@dateNowGMT
                ,@realCardTypeId
                ,@cvvPassedFlag
                ,@productId
                ,@dateNowGMT
                ,@avsPassedFlag
            )

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updCreditCard
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updCreditCard
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updCreditCard TO web
go

IF OBJECT_ID('dbo.wsp_updCreditCard') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCreditCard >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCreditCard >>>'
go

EXEC sp_procxmode 'dbo.wsp_updCreditCard','unchained'
go
