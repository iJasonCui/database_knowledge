IF OBJECT_ID('dbo.wsp_getAllSubscriptionTypes') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllSubscriptionTypes
    IF OBJECT_ID('dbo.wsp_getAllSubscriptionTypes') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllSubscriptionTypes >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllSubscriptionTypes >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  November 2004
**   Description:  retrieves all subscription types
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllSubscriptionTypes
AS
  BEGIN  
	SELECT 
          subscriptionTypeId,
          contentId,
          description
        FROM SubscriptionType
        ORDER BY subscriptionTypeId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllSubscriptionTypes') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllSubscriptionTypes >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllSubscriptionTypes >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllSubscriptionTypes TO web
go

