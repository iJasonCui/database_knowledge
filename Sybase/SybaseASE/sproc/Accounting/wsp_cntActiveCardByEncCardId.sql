IF OBJECT_ID('dbo.wsp_cntActiveCardByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntActiveCardByEncCardId
    IF OBJECT_ID('dbo.wsp_cntActiveCardByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntActiveCardByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntActiveCardByEncCardId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:       Andy Tran
**   Date:         February 2008
**   Description:  Find if the credit card is being used in our system
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE dbo.wsp_cntActiveCardByEncCardId
 @encodedCardId INT
,@userId        NUMERIC(12,0)
AS

BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
       AND userId != @userId
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntActiveCardByEncCardId TO web
go

IF OBJECT_ID('dbo.wsp_cntActiveCardByEncCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntActiveCardByEncCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntActiveCardByEncCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntActiveCardByEncCardId','unchained'
go
