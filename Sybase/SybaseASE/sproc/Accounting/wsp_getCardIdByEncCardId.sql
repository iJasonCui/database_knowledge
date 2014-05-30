IF OBJECT_ID('dbo.wsp_getCardIdByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getCardIdByEncCardId
    IF OBJECT_ID('dbo.wsp_getCardIdByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getCardIdByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getCardIdByEncCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Retrieves card id for the specified number
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_getCardIdByEncCardId
 @encodedCardId INT
AS

BEGIN
    SELECT creditCardId
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getCardIdByEncCardId TO web
go

IF OBJECT_ID('dbo.wsp_getCardIdByEncCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_getCardIdByEncCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getCardIdByEncCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_getCardIdByEncCardId','unchained'
go
