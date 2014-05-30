IF OBJECT_ID('dbo.wsp_updCCTranFromWait') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updCCTranFromWait
    IF OBJECT_ID('dbo.wsp_updCCTranFromWait') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updCCTranFromWait >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updCCTranFromWait >>>'
END
go
CREATE PROCEDURE dbo.wsp_updCCTranFromWait
  @xactionId  numeric(12,0)

AS
  DECLARE @rowcount int
  DECLARE @error int
  
  BEGIN TRAN wsp_updCCTranFromWait

  UPDATE CreditCardTransaction
  SET CCTranStatusId = 1
  WHERE xactionId = @xactionId
  AND CCTranStatusId = 6  

  SELECT @error = @@error, @rowcount = @@rowcount
  IF @error = 0 
  BEGIN
    COMMIT TRAN wsp_updCCTranFromWait
  END 
  ELSE 
  BEGIN
    ROLLBACK TRAN wsp_updCCTranFromWait
  END
  
  IF @rowcount = 0
  BEGIN
        RAISERROR 20001 'Error, @xactionId %1! is not in wait state or does not exist.', @xactionId
        RETURN 20001
  END
  
  
  SELECT @error AS RESULT,@rowcount AS ROWCNT,@xactionId AS PRIMKEY

go
IF OBJECT_ID('dbo.wsp_updCCTranFromWait') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updCCTranFromWait >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updCCTranFromWait >>>'
go
EXEC sp_procxmode 'dbo.wsp_updCCTranFromWait','unchained'
go
GRANT EXECUTE ON dbo.wsp_updCCTranFromWait TO web
go
