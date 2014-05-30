IF OBJECT_ID('dbo.wsp_cntBadCardByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntBadCardByEncCardId
    IF OBJECT_ID('dbo.wsp_cntBadCardByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntBadCardByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntBadCardByEncCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Find if the credit card is marked as bad in our system
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntBadCardByEncCardId
 @encodedCardId INT
AS

BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
       AND status = 'B'
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END

go
IF OBJECT_ID('dbo.wsp_cntBadCardByEncCardId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntBadCardByEncCardId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntBadCardByEncCardId >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntBadCardByEncCardId','unchained'
go
GRANT EXECUTE ON dbo.wsp_cntBadCardByEncCardId TO web
go

