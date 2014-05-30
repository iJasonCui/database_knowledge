IF OBJECT_ID('dbo.wsp_updAccountingEventEnc') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updAccountingEventEnc
    IF OBJECT_ID('dbo.wsp_updAccountingEventEnc') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updAccountingEventEnc >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updAccountingEventEnc >>>'
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

CREATE PROCEDURE dbo.wsp_updAccountingEventEnc
 @encodedCardNum VARCHAR(64)
,@encodedCardId  INT
AS

IF EXISTS (SELECT 1 FROM AccountingEvent WHERE encodedCardNum = @encodedCardNum)
    BEGIN
        BEGIN TRAN TRAN_updAccountingEventEnc
            UPDATE AccountingEvent
               SET encodedCardNum = ''
                  ,encodedCardId = @encodedCardId
             WHERE encodedCardNum = @encodedCardNum

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updAccountingEventEnc
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updAccountingEventEnc
                    RETURN 99
                END
    END
go

GRANT EXECUTE ON dbo.wsp_updAccountingEventEnc TO web
go

IF OBJECT_ID('dbo.wsp_updAccountingEventEnc') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updAccountingEventEnc >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updAccountingEventEnc >>>'
go

EXEC sp_procxmode 'dbo.wsp_updAccountingEventEnc','unchained'
go
