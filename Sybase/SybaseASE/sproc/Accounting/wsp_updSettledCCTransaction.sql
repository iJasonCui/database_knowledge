IF OBJECT_ID('dbo.wsp_updSettledCCTransaction') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updSettledCCTransaction
    IF OBJECT_ID('dbo.wsp_updSettledCCTransaction') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updSettledCCTransaction >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updSettledCCTransaction >>>'
END
go

/*******************************************************************
**
** CREATION:
**   Author:      Mike Stairs
**   Date:        May 30 2005 
**   Description: updates settled/rejected transaction row in CreditCardTransaction
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
*******************************************************************/

CREATE PROCEDURE wsp_updSettledCCTransaction
 @xactionId         NUMERIC(12,0)
,@CCTranStatusId    INT
,@responseCode      SMALLINT
,@cardNumber        VARCHAR(64)
,@partialCardNumber CHAR(4)
,@merchantId        CHAR(10)
,@amount            NUMERIC(10,0)
,@cardType          CHAR(2)
,@currencyCode      CHAR(3)
,@responseDate      CHAR(6)
AS
DECLARE
 @return          INT
,@dateGMT         DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateGMT OUTPUT
IF @return != 0
    BEGIN
        RETURN @return
    END

BEGIN TRAN TRAN_updSettledCCTransaction

  INSERT INTO SettlementResponse  
   (
     xactionId,
     responseCode,
     responseDate,
     cardNumber,
     partialCardNumber,
     cardType,
     amount,
     merchantId,
     currencyCode,
     dateCreated
  )
  VALUES (
     @xactionId,
     @responseCode,
     @responseDate,
     @cardNumber,
     @partialCardNumber,
     @cardType,
     @amount,
     @merchantId,
     @currencyCode,
     @dateGMT
  )

  IF @@error != 0
    BEGIN
        ROLLBACK TRAN TRAN_updSettledCCTransaction
        RETURN 98
    END
 
  UPDATE CreditCardTransaction 
     SET dateSettled = @dateGMT,
         CCTranStatusId = @CCTranStatusId,
         responseCode = @responseCode
  WHERE xactionId = @xactionId

  IF @@error = 0
    BEGIN
        COMMIT TRAN TRAN_updSettledCCTransaction
        RETURN 0
    END
  ELSE
    BEGIN
        ROLLBACK TRAN TRAN_updSettledCCTransaction
        RETURN 99
    END

go

GRANT EXECUTE ON dbo.wsp_updSettledCCTransaction TO web
go

IF OBJECT_ID('dbo.wsp_updSettledCCTransaction') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updSettledCCTransaction >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updSettledCCTransaction >>>'
go

EXEC sp_procxmode 'dbo.wsp_updSettledCCTransaction','unchained'
go
