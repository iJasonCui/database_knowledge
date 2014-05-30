IF OBJECT_ID('dbo.wsp_getAllCurrencies') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllCurrencies
    IF OBJECT_ID('dbo.wsp_getAllCurrencies') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllCurrencies >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllCurrencies >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all currencies
**
**
** REVISION(S):
**   Author:        Andy Tran
**   Date:          July 26, 2004
**   Description:   adds contentId
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllCurrencies
AS
  BEGIN  
	SELECT 
          currencyId,
          currencyCode,
          currencyDesc,
          currencySymbol,
          convertUSD,
          precisionDigits,
          dateModified,
          contentId
        FROM Currency
        ORDER BY currencyId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllCurrencies') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllCurrencies >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllCurrencies >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllCurrencies TO web
go

