IF OBJECT_ID('dbo.wsp_updSettledCCTransactionEnc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updSettledCCTransactionEnc
    IF OBJECT_ID('dbo.wsp_updSettledCCTransactionEnc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updSettledCCTransactionEnc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updSettledCCTransactionEnc >>>'
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

CREATE PROCEDURE wsp_updSettledCCTransactionEnc
 @encodedCardNum VARCHAR(64)
,@encodedCardId  INT
AS

IF EXISTS (SELECT 1 FROM SettlementResponse WHERE cardNumber = @encodedCardNum)
    BEGIN
        BEGIN TRAN TRAN_updSettlementResponseEnc
            UPDATE SettlementResponse
               SET cardNumber = ''
                  ,encodedCardId = @encodedCardId
             WHERE cardNumber = @encodedCardNum

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updSettlementResponseEnc
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updSettlementResponseEnc
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updSettledCCTransactionEnc TO web
go

IF OBJECT_ID('dbo.wsp_updSettledCCTransactionEnc') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updSettledCCTransactionEnc >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updSettledCCTransactionEnc >>>'
go

EXEC sp_procxmode 'dbo.wsp_updSettledCCTransactionEnc','unchained'
go
