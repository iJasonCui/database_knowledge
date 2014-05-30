IF OBJECT_ID('dbo.wsp_getCreditCardIdByNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCreditCardIdByNumber
    IF OBJECT_ID('dbo.wsp_getCreditCardIdByNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCreditCardIdByNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCreditCardIdByNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       SK
**   Date:         Oct 6, 2003
**   Description:  retrieves credit card id for the specified number
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCreditCardIdByNumber
@cardNum varchar(64)
AS

BEGIN
    SELECT creditCardId
      FROM CreditCard
     WHERE cardNum = @cardNum
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCreditCardIdByNumber TO web
go

IF OBJECT_ID('dbo.wsp_getCreditCardIdByNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCreditCardIdByNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCreditCardIdByNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCreditCardIdByNumber','unchained'
go
