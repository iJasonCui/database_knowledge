IF OBJECT_ID('dbo.wsp_cntBadCardByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntBadCardByCardNumber
    IF OBJECT_ID('dbo.wsp_cntBadCardByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntBadCardByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntBadCardByCardNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Oct 24, 2003
**   Description:  Find if the credit card is marked as bad in our system
**
** REVISION(S):
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntBadCardByCardNumber
 @encodedCardNum VARCHAR(64)
AS

BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
       AND status = 'B'
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END

go
IF OBJECT_ID('dbo.wsp_cntBadCardByCardNumber') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntBadCardByCardNumber >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntBadCardByCardNumber >>>'
go
EXEC sp_procxmode 'dbo.wsp_cntBadCardByCardNumber','unchained'
go
GRANT EXECUTE ON dbo.wsp_cntBadCardByCardNumber TO web
go

