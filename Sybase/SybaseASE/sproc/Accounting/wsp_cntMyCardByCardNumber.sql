IF OBJECT_ID('dbo.wsp_cntMyCardByCardNumber') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntMyCardByCardNumber
    IF OBJECT_ID('dbo.wsp_cntMyCardByCardNumber') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntMyCardByCardNumber >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntMyCardByCardNumber >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Mirjana Cetojevic
**   Date:         December 9, 2004
**   Description:  Find if the credit card is being used by the same user in our system
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

CREATE PROCEDURE dbo.wsp_cntMyCardByCardNumber
 @encodedCardNum VARCHAR(64)
,@userId         NUMERIC(12,0)
AS

BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardNum = @encodedCardNum
       AND userId = @userId
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntMyCardByCardNumber TO web
go

IF OBJECT_ID('dbo.wsp_cntMyCardByCardNumber') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntMyCardByCardNumber >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntMyCardByCardNumber >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntMyCardByCardNumber','unchained'
go
