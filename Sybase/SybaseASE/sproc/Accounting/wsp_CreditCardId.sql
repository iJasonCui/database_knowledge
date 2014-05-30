IF OBJECT_ID('dbo.wsp_CreditCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_CreditCardId
    IF OBJECT_ID('dbo.wsp_CreditCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_CreditCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_CreditCardId >>>'
END
go
  /******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Sept 2003
**   Description:  Generation of CreditCardId
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_CreditCardId @creditCardId INT OUTPUT
AS

BEGIN TRAN TRAN_wsp_CreditCardId
    UPDATE CreditCardId
    SET creditCardId = creditCardId + 1

    IF @@error = 0
        BEGIN
            SELECT @creditCardId = creditCardId
            FROM CreditCardId
            COMMIT TRAN TRAN_wsp_CreditCardId
		  RETURN 0
        END
    ELSE
        BEGIN
            ROLLBACK TRAN TRAN_wsp_CreditCardId
		  RETURN 99
        END 

go
GRANT EXECUTE ON dbo.wsp_CreditCardId TO web
go
IF OBJECT_ID('dbo.wsp_CreditCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_CreditCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_CreditCardId >>>'
go

