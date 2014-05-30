IF OBJECT_ID('dbo.wsp_delBadCreditCard') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_delBadCreditCard
    IF OBJECT_ID('dbo.wsp_delBadCreditCard') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_delBadCreditCard >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_delBadCreditCard >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Slobodan Kandic
**   Date:  Sep 29, 2003
**   Description:
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE  wsp_delBadCreditCard
 @creditCardId int
AS

BEGIN TRAN TRAN_delBadCreditCard

DELETE FROM BadCreditCard
WHERE creditCardId = @creditCardId

IF @@error = 0
  BEGIN
    UPDATE CreditCard
    SET status = 'I'
	WHERE creditCardId = @creditCardId
	
	IF @@error = 0
	BEGIN
    	COMMIT TRAN TRAN_delBadCreditCard
    	RETURN 0
    END
    ELSE
    BEGIN
	    ROLLBACK TRAN TRAN_delBadCreditCard
    	RETURN 98
    END
    
  END
ELSE
  BEGIN
    ROLLBACK TRAN TRAN_delBadCreditCard
    RETURN 99
  END 
 
go
GRANT EXECUTE ON dbo.wsp_delBadCreditCard TO web
go
IF OBJECT_ID('dbo.wsp_delBadCreditCard') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_delBadCreditCard >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_delBadCreditCard >>>'
go
EXEC sp_procxmode 'dbo.wsp_delBadCreditCard','unchained'
go
