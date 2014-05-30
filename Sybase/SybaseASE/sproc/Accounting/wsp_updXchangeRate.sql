IF OBJECT_ID('dbo.wsp_updXchangeRate') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updXchangeRate
    IF OBJECT_ID('dbo.wsp_updXchangeRate') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updXchangeRate >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updXchangeRate >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Oct 10, 2003
**   Description:  updates exchange rate for given currency
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updXchangeRate
@currencyId            NUMERIC(12,0),
@convertUSD            NUMERIC(12,5),
@adminUserId           INT
AS

DECLARE @return 		INT
,@dateNow 			DATETIME

EXEC @return = dbo.wsp_GetDateGMT @dateNow OUTPUT
	
IF @return != 0
	BEGIN
		RETURN @return
	END

  BEGIN TRAN TRAN_updXchangeRate

  UPDATE Currency
  SET convertUSD = @convertUSD,
      dateModified = @dateNow
  WHERE 
      currencyId = @currencyId

  IF @@error != 0
	BEGIN
		ROLLBACK TRAN TRAN_updXchangeRate
		RETURN 98
	END

  INSERT INTO CurrencyHistory
      ( currencyId,
        convertUSD,
        adminUserId,
        dateCreated)
  VALUES
      ( @currencyId,
        @convertUSD,
        @adminUserId,
        @dateNow)
        
  IF @@error = 0
	BEGIN
		COMMIT TRAN TRAN_updXchangeRate
		RETURN 0
	END
  ELSE
	BEGIN
		ROLLBACK TRAN TRAN_updXchangeRate
		RETURN 98
	END
go
IF OBJECT_ID('dbo.wsp_updXchangeRate') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updXchangeRate >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updXchangeRate >>>'
go
GRANT EXECUTE ON dbo.wsp_updXchangeRate TO web
go

