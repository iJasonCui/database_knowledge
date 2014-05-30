IF OBJECT_ID('dbo.wsp_cntMyCardByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntMyCardByEncCardId
    IF OBJECT_ID('dbo.wsp_cntMyCardByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntMyCardByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntMyCardByEncCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Find if the credit card is being used by the same user in our system
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntMyCardByEncCardId
 @encodedCardId INT
,@userId        NUMERIC(12,0)
AS

BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
       AND userId = @userId
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntMyCardByEncCardId TO web
go

IF OBJECT_ID('dbo.wsp_cntMyCardByEncCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntMyCardByEncCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntMyCardByEncCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntMyCardByEncCardId','unchained'
go
