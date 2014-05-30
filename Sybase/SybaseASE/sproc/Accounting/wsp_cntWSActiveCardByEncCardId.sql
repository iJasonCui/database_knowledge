IF OBJECT_ID('dbo.wsp_cntWSActiveCardByEncCardId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId
    IF OBJECT_ID('dbo.wsp_cntWSActiveCardByEncCardId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId >>>'
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

CREATE PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId
 @encodedCardId INT
,@userId        NUMERIC(12,0)
,@productId     SMALLINT
AS

BEGIN

  IF @productId  > 0
  BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
       AND userId != @userId
       AND productId = @productId
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED
  END
  ELSE
  BEGIN
    SELECT count(*)
      FROM CreditCard
     WHERE encodedCardId = @encodedCardId
       AND userId != @userId
       AND productId = 0 
       AND status NOT IN ('I', 'D')
    AT ISOLATION READ UNCOMMITTED
  END

    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_cntWSActiveCardByEncCardId TO web
go

IF OBJECT_ID('dbo.wsp_cntWSActiveCardByEncCardId') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntWSActiveCardByEncCardId >>>'
go

EXEC sp_procxmode 'dbo.wsp_cntWSActiveCardByEncCardId','unchained'
go
