IF OBJECT_ID('dbo.wsp_cntWActiveCardByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntWActiveCardByCardNumber
    IF OBJECT_ID('dbo.wsp_cntWActiveCardByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntWActiveCardByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntWActiveCardByCardNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         Sept 9, 2003
**   Description:  Find if the credit card is being used in our system
**
** REVISION(S):
**   Author:       Mike Stairs
**   Date:
**   Description:  Changed to check status not inactive, so include banned cards as used
**
**   Author:       Andy Tran
**   Date:         Feb 17, 2005
**   Description:  Used encodedCardNum
**
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntWActiveCardByCardNumber
 @encodedCardNum VARCHAR(64)
,@userId         NUMERIC(12,0)
,@productId      SMALLINT 
AS

BEGIN

    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
       AND userId != @userId
       AND productId = @productId
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntWActiveCardByCardNumber TO web
go

IF OBJECT_ID('dbo.wsp_cntWActiveCardByCardNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntWActiveCardByCardNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntWActiveCardByCardNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntWActiveCardByCardNumber','unchained'
go
