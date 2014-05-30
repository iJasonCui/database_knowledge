IF OBJECT_ID('dbo.wsp_getAllUsageTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllUsageTypes
    IF OBJECT_ID('dbo.wsp_getAllUsageTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllUsageTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllUsageTypes >>>'
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
**   Author:
**   Date:
**   Description:
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllUsageTypes
AS
  BEGIN  
	SELECT 
          usageTypeId,
          contentId,
          xactionTypeId,
          hasDuration,
          appletDesc
        FROM UsageType
        ORDER BY usageTypeId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllUsageTypes') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllUsageTypes >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllUsageTypes >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllUsageTypes TO web
go

