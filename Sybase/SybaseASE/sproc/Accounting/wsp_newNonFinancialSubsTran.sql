
IF OBJECT_ID('dbo.wsp_newNonFinancialSubsTran') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_newNonFinancialSubsTran
    IF OBJECT_ID('dbo.wsp_newNonFinancialSubsTran') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_newNonFinancialSubsTran >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_newNonFinancialSubsTran >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  January 04, 2005
**   Description:  add non financial subscription transaction for user
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_newNonFinancialSubsTran
@cardId              INT,
@userId              NUMERIC(12,0),
@contentId           SMALLINT,
@subscriptionTypeId  SMALLINT,
@duration            SMALLINT,
@dateCreated         DATETIME
AS

BEGIN  

  DECLARE  @return1  INT,
           @return2  INT,
           @returnId INT,
           @dateNowGMT DATETIME

  EXEC @return1 = dbo.wsp_GetDateGMT @dateNowGMT OUTPUT

  IF @return1 != 0
  BEGIN
    RETURN @return1
  END


  EXEC @return2 = dbo.wsp_nonFinancialXActionId @returnId OUTPUT

  IF @return2 != 0
  BEGIN
    RETURN @return2
  END

    INSERT INTO SubscriptionNonfinancialTrans
    (nonFinancialXActionId,cardId,userId,contentId,subscriptionTypeId,duration,dateCreated)
    VALUES
    (@returnId,@cardId,@userId,@contentId,@subscriptionTypeId,@duration,@dateNowGMT)

    RETURN @@error

END
go
IF OBJECT_ID('dbo.wsp_newNonFinancialSubsTran') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_newNonFinancialSubsTran >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_newNonFinancialSubsTran >>>'
go
GRANT EXECUTE ON dbo.wsp_newNonFinancialSubsTran TO web
go
