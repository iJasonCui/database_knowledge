IF OBJECT_ID('dbo.wsp_getCardIdByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardIdByCardNumber
    IF OBJECT_ID('dbo.wsp_getCardIdByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardIdByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardIdByCardNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       SK
**   Date:         Oct 6, 2003
**   Description:  Retrieves card id for the specified number
**
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**                 Renamed from wsp_getCreditCardByNumber
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCardIdByCardNumber
 @encodedCardNum VARCHAR(64)
AS

BEGIN
    SELECT creditCardId
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardIdByCardNumber TO web
go

IF OBJECT_ID('dbo.wsp_getCardIdByCardNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardIdByCardNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardIdByCardNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardIdByCardNumber','unchained'
go
