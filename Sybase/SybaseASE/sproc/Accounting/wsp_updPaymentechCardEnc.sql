IF OBJECT_ID('dbo.wsp_updPaymentechCardEnc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updPaymentechCardEnc
    IF OBJECT_ID('dbo.wsp_updPaymentechCardEnc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updPaymentechCardEnc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updPaymentechCardEnc >>>'
END
go

/*******************************************************************
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
*******************************************************************/

CREATE PROCEDURE wsp_updPaymentechCardEnc
 @encodedCardNum VARCHAR(64)
,@encodedCardId  INT
AS

IF EXISTS (SELECT 1 FROM PaymentechRequest WHERE cardNumber = @encodedCardNum)
    BEGIN
        BEGIN TRAN TRAN_updPaymentechRequestEnc
            UPDATE PaymentechRequest
               SET cardNumber = ''
                  ,encodedCardId = @encodedCardId
             WHERE cardNumber = @encodedCardNum

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updPaymentechRequestEnc
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updPaymentechRequestEnc
                    RETURN 99
                END
    END

IF EXISTS (SELECT 1 FROM PaymentechResponse WHERE cardNumber = @encodedCardNum)
    BEGIN
        BEGIN TRAN TRAN_updPaymentechResponseEnc
            UPDATE PaymentechResponse
               SET cardNumber = ''
                  ,encodedCardId = @encodedCardId
             WHERE cardNumber = @encodedCardNum

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updPaymentechResponseEnc
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updPaymentechResponseEnc
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updPaymentechCardEnc TO web
go

IF OBJECT_ID('dbo.wsp_updPaymentechCardEnc') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updPaymentechCardEnc >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updPaymentechCardEnc >>>'
go

EXEC sp_procxmode 'dbo.wsp_updPaymentechCardEnc','unchained'
go
