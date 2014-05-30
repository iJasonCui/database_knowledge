IF OBJECT_ID('dbo.wsp_getAllSubscriptionOffers') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllSubscriptionOffers
    IF OBJECT_ID('dbo.wsp_getAllSubscriptionOffers') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllSubscriptionOffers >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllSubscriptionOffers >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  Nov, 2004
**   Description:  retrieves all subscription offers
**
**
** REVISION(S):
**   Author: Mike Stairs
**   Date: Feb 3, 2006
**   Description: also return expired subscription offers
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getAllSubscriptionOffers
AS

  BEGIN  
	SELECT 
          subscriptionOfferId,
          currencyId,
          dateExpiry,
          description
        FROM SubscriptionOffer
        ORDER BY subscriptionOfferId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllSubscriptionOffers') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllSubscriptionOffers >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllSubscriptionOffers >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllSubscriptionOffers TO web
go

