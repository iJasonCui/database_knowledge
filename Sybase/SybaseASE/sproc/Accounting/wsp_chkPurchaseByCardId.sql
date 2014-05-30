IF OBJECT_ID('dbo.wsp_chkPurchaseByCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_chkPurchaseByCardId
    IF OBJECT_ID('dbo.wsp_chkPurchaseByCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_chkPurchaseByCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_chkPurchaseByCardId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Andy Tran
**   Date:  June 2008
**   Description:  check if a purchase was made with the credit card before
**
** REVISION(S):
**   Author:
**   Date: 
**   Description: 
**
******************************************************************************/
CREATE PROCEDURE  wsp_chkPurchaseByCardId
 @cardId INT

AS

BEGIN
    BEGIN TRAN TRAN_chkPurchaseByCardId
        SELECT 1 AS isExisted
          FROM Purchase p, CreditCard c
         WHERE p.creditCardId = @cardId
           AND p.xactionTypeId IN (6, 31) -- successful purchase
           AND p.creditCardId = c.creditCardId
           AND p.dateCreated > c.dateCreated

        IF @@error = 0
            BEGIN
                COMMIT TRAN TRAN_chkPurchaseByCardId
            END
        ELSE
            BEGIN
                ROLLBACK TRAN TRAN_chkPurchaseByCardId
            END
END
go

GRANT EXECUTE ON dbo.wsp_chkPurchaseByCardId TO web
go

IF OBJECT_ID('dbo.wsp_chkPurchaseByCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_chkPurchaseByCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_chkPurchaseByCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_chkPurchaseByCardId','unchained'
go
