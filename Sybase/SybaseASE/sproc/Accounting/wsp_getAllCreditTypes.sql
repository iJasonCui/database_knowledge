IF OBJECT_ID('dbo.wsp_getAllCreditTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllCreditTypes
    IF OBJECT_ID('dbo.wsp_getAllCreditTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllCreditTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllCreditTypes >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  May 21, 2003
**   Description:  retrieves all credit types
**
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllCreditTypes
AS
  BEGIN  
	SELECT 
          creditTypeId,
          contentId,
          ordinal,
          duration
        FROM CreditType
        ORDER BY creditTypeId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllCreditTypes') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllCreditTypes >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllCreditTypes >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllCreditTypes TO web
go

