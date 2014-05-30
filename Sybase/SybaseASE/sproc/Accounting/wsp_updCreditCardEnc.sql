IF OBJECT_ID('dbo.wsp_updCreditCardEnc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCreditCardEnc
    IF OBJECT_ID('dbo.wsp_updCreditCardEnc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCreditCardEnc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCreditCardEnc >>>'
END
go

/******************************************************************************
 **
 ** CREATION:
 **   Author:       Andy Tran
 **   Date:         February 2008
 **   Description:  replace encodedCardNum with encodedCardId.
 **
 ** REVISION(S):
 **   Author:
 **   Date:
 **   Description:
 **
 ******************************************************************************/

CREATE PROCEDURE dbo.wsp_updCreditCardEnc
 @encodedCardNum VARCHAR(64)
,@encodedCardId  INT
AS

DECLARE
 @return      INT
,@dateNowGMT  DATETIME
,@timeStamp   VARCHAR(64)

EXEC @return = wsp_GetDateGMT @dateNowGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

SELECT @timeStamp = CONVERT(VARCHAR(64), DATEDIFF(ss, '1970-01-01 00:00:00', @dateNowGMT))

IF EXISTS (SELECT 1 FROM CreditCard WHERE encodedCardNum = @encodedCardNum)
    BEGIN
        BEGIN TRAN TRAN_updCreditCardEnc
            UPDATE CreditCard
               SET encodedCardNum = @timeStamp -- keep unique index
                  ,encodedCardId = @encodedCardId
                  ,dateModified = @dateNowGMT
             WHERE encodedCardNum = @encodedCardNum

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updCreditCardEnc
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updCreditCardEnc
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updCreditCardEnc TO web
go

IF OBJECT_ID('dbo.wsp_updCreditCardEnc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updCreditCardEnc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCreditCardEnc >>>'
go

EXEC sp_procxmode 'dbo.wsp_updCreditCardEnc','unchained'
go
