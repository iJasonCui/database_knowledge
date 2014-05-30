IF OBJECT_ID('dbo.wsp_extractCCTran') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_extractCCTran
    IF OBJECT_ID('dbo.wsp_extractCCTran') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_extractCCTran >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_extractCCTran >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:    May 27 2005
**   Description: Extract a credit card transaction which has been authorized for settlement 
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_extractCCTran
  @xactionId numeric(12,0)

AS
  DECLARE @rowcount int
  DECLARE @error int
  DECLARE @return	INT
  DECLARE @dateGMT	DATETIME

  EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
  IF @return != 0
  BEGIN
     RETURN @return
  END
  
  BEGIN TRAN wsp_extractCCTran

  UPDATE CreditCardTransaction
  SET CCTranStatusId = 3,
      dateExtracted = @dateGMT
  WHERE xactionId = @xactionId
  AND CCTranStatusId = 1  

  SELECT @error = @@error, @rowcount = @@rowcount
  IF @error = 0 
  BEGIN
    COMMIT TRAN wsp_extractCCTran
  END 
  ELSE 
  BEGIN
    ROLLBACK TRAN wsp_extractCCTran
  END
  
  IF @rowcount = 0
  BEGIN
        RAISERROR 20001 'Error, xactionId %1! has been extracted or does not exist.', @xactionId
        RETURN 20001
  END
  
  SELECT @error AS RESULT,@rowcount AS ROWCNT,@xactionId AS PRIMKEY

go
IF OBJECT_ID('dbo.wsp_extractCCTran') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_extractCCTran >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_extractCCTran >>>'
go
EXEC sp_procxmode 'dbo.wsp_extractCCTran','unchained'
go
GRANT EXECUTE ON dbo.wsp_extractCCTran TO web
go

