IF OBJECT_ID('dbo.wsp_updBadCreditCardAsGood') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updBadCreditCardAsGood
    IF OBJECT_ID('dbo.wsp_updBadCreditCardAsGood') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updBadCreditCardAsGood >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updBadCreditCardAsGood >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 6, 2003
**   Description:
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_updBadCreditCardAsGood
 @creditCardId int
AS

BEGIN TRAN TRAN_updBadCreditCardAsGood

UPDATE CreditCard SET status='I' WHERE creditCardId = @creditCardId

IF @@error = 0
  BEGIN 
    UPDATE BadCreditCard SET status='I' WHERE creditCardId = @creditCardId

    IF @@error = 0
       BEGIN
         COMMIT TRAN TRAN_updBadCreditCardAsGood
         RETURN 0
       END
    ELSE
       BEGIN
         ROLLBACK TRAN TRAN_updBadCreditCardAsGood
         RETURN 99
       END
    END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_updBadCreditCardAsGood
    RETURN 99
  END 
 
go
GRANT EXECUTE ON dbo.wsp_updBadCreditCardAsGood TO web
go
IF OBJECT_ID('dbo.wsp_updBadCreditCardAsGood') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_updBadCreditCardAsGood >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updBadCreditCardAsGood >>>'
go
EXEC sp_procxmode 'dbo.wsp_updBadCreditCardAsGood','unchained'
go
