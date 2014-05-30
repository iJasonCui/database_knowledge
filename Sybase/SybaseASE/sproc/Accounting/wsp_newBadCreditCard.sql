IF OBJECT_ID('dbo.wsp_newBadCreditCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newBadCreditCard
    IF OBJECT_ID('dbo.wsp_newBadCreditCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newBadCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newBadCreditCard >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Oct 3, 2003
**   Description:  marks a card as bad
**
** REVISION(S):
**   Author:		
**   Date:		
**   Description:	
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_newBadCreditCard
     @creditCardId      INT,
     @reasonContentId   SMALLINT,
     @reason            VARCHAR(255)

AS

DECLARE
 @return      INT
,@now  DATETIME

EXEC @return = wsp_GetDateGMT @now OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

IF EXISTS (SELECT 1 FROM CreditCard WHERE creditCardId = @creditCardId)
  BEGIN TRAN TRAN_newBadCreditCard
     UPDATE CreditCard
     SET 
       status = 'B'
       ,dateModified = @now
     WHERE creditCardId = @creditCardId

     IF @@error = 0
         BEGIN       
           IF EXISTS (SELECT 1 FROM BadCreditCard WHERE creditCardId = @creditCardId)
             BEGIN
               UPDATE BadCreditCard
               SET reason = @reason,
                   reasonContentId = @reasonContentId,
                   dateModified = @now,
                   status = 'B'
               WHERE creditCardId = @creditCardId
               IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_newBadCreditCard
                    RETURN 0
                END
               ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_newBadCreditCard
                    RETURN 99
                END
            END
            ELSE
            BEGIN
               INSERT INTO BadCreditCard
               ( creditCardId,
                 reason,
                 reasonContentId,
                 dateCreated,
                 dateModified,
                 status
               ) VALUES
               ( @creditCardId,
                 @reason,
                 @reasonContentId,
                 @now,
                 @now,
                 'B' )
               IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_newBadCreditCard
                    RETURN 0
                END
               ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_newBadCreditCard
                    RETURN 99
                END
            END
    END
go

GRANT EXECUTE ON dbo.wsp_newBadCreditCard TO web
go

IF OBJECT_ID('dbo.wsp_newBadCreditCard') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_newBadCreditCard >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newBadCreditCard >>>'
go

EXEC sp_procxmode 'dbo.wsp_newBadCreditCard','unchained'
go
