IF OBJECT_ID('dbo.wsp_updAccountingEvent') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updAccountingEvent
    IF OBJECT_ID('dbo.wsp_updAccountingEvent') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updAccountingEvent >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updAccountingEvent >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:        Slobodan Kandic
**   Date:          Oct 03 2003 at 09:13AM
**   Description:
**
** REVISION(S):
 **   Author:       Andy Tran
 **   Date:         February 2008
 **   Description:  replace encodedCardNum with encodedCardId.
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_updAccountingEvent
 @userId NUMERIC(12,0)
,@eventType CHAR(1)
,@xactionId NUMERIC(12,0)
,@encodedCardNum VARCHAR(64)
,@dateCreated DATETIME
AS

IF EXISTS (SELECT 1 FROM AccountingEvent WHERE userId = @userId AND dateCreated = @dateCreated AND eventType = @eventType)
    BEGIN
        BEGIN TRAN TRAN_updAccountingEvent
            UPDATE AccountingEvent
                  SET xactionId = @xactionId
                     ,encodedCardNum = @encodedCardNum
              WHERE userId = @userId
               AND dateCreated = @dateCreated
               AND eventType = @eventType

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_updAccountingEvent
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_updAccountingEvent
                    RETURN 99
                END
    END
ELSE
    BEGIN
        BEGIN TRAN TRAN_newAccountingEvent
            INSERT INTO AccountingEvent (
                 userId
                ,eventType
                ,xactionId
                ,cardNum
                ,encodedCardNum
                ,dateCreated
            )
            VALUES (
                 @userId
                ,@eventType
                ,@xactionId
                ,''
                ,@encodedCardNum
                ,@dateCreated
            )
        
            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_newAccountingEvent
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_newAccountingEvent
                    RETURN 99
                END
    END 
go

GRANT EXECUTE ON dbo.wsp_updAccountingEvent TO web
go

IF OBJECT_ID('dbo.wsp_updAccountingEvent') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updAccountingEvent >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updAccountingEvent >>>'
go

EXEC sp_procxmode 'dbo.wsp_updAccountingEvent','unchained'
go
