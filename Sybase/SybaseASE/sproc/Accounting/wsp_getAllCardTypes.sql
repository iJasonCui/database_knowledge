IF OBJECT_ID('dbo.wsp_getAllCardTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllCardTypes
    IF OBJECT_ID('dbo.wsp_getAllCardTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllCardTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllCardTypes >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all usage types
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 13, 2004
**   Description: added debitFlag column
**
**   Author: Mike Stairs
**   Date: June 17, 2005
**   Description: added cvvRequiredFlag column
**
**   Author: Andy Tran
**   Date: July 12, 2010
**   Description: added cardTypeCode column
**
**   Author: Andy Tran
**   Date: February 2011
**   Description: added avsRequiredFlag column
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllCardTypes
AS
  BEGIN  
	SELECT 
          cardTypeId,
          nicknameContentId,
          contentId,
          currencyId,
          merchantId,
          debitFlag,
          bankCardFlag,
          expiryRequiredFlag,
          startDateRequiredFlag,
          cvvRequiredFlag,
          cardTypeCode,
          avsRequiredFlag
        FROM CardType
        ORDER BY displayOrdinal
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllCardTypes') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllCardTypes >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllCardTypes >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllCardTypes TO web
go

