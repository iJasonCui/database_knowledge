IF OBJECT_ID('dbo.wsp_inactivateCardByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_inactivateCardByUserId
    IF OBJECT_ID('dbo.wsp_inactivateCardByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_inactivateCardByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_inactivateCardByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mike Stairs
**   Date:         Oct, 2004
**   Description:  mark all credit card to inactive.
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_inactivateCardByUserId
    @userId            NUMERIC(12,0)
AS

DECLARE
 @return      INT
,@GetDateGMT  DATETIME


EXEC @return = wsp_GetDateGMT @GetDateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

    BEGIN TRAN TRAN_inactivateCardByUserId
            UPDATE CreditCard
               SET 
                  status = 'I'
                  ,dateModified = @GetDateGMT
             WHERE userId = @userId

            IF @@error = 0
                BEGIN
                    COMMIT TRAN TRAN_inactivateCardByUserId
                    RETURN 0
                END
            ELSE
                BEGIN
                    ROLLBACK TRAN TRAN_inactivateCardByUserId
                    RETURN 99
                END
go

GRANT EXECUTE ON dbo.wsp_inactivateCardByUserId TO web
go

IF OBJECT_ID('dbo.wsp_inactivateCardByUserId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_inactivateCardByUserId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_inactivateCardByUserId >>>'
go

EXEC sp_procxmode 'dbo.wsp_inactivateCardByUserId','unchained'
go
