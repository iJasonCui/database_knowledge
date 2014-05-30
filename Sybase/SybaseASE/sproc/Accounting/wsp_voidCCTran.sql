IF OBJECT_ID('dbo.wsp_voidCCTran') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_voidCCTran
    IF OBJECT_ID('dbo.wsp_voidCCTran') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_voidCCTran >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_voidCCTran >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Jason C.
**   Date:    May 16 2005
**   Description:  void a credit card transaction which has been authorized (can only void a new/pending tran)
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_voidCCTran
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
  
  BEGIN TRAN wsp_voidCCTran

  UPDATE CreditCardTransaction
  SET CCTranStatusId = 2,
      dateVoided = @dateGMT
  WHERE xactionId = @xactionId
  AND CCTranStatusId = 1  

  SELECT @@rowcount

  IF @@error = 0 
  BEGIN
    COMMIT TRAN wsp_voidCCTran
    RETURN 0
  END 
  ELSE 
  BEGIN
    ROLLBACK TRAN wsp_voidCCTran
    RETURN 1
  END

go
EXEC sp_procxmode 'dbo.wsp_voidCCTran','unchained'
go
IF OBJECT_ID('dbo.wsp_voidCCTran') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_voidCCTran >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_voidCCTran >>>'
go
GRANT EXECUTE ON dbo.wsp_voidCCTran TO web
go

