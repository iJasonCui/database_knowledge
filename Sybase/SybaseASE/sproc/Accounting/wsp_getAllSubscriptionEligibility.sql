IF OBJECT_ID('dbo.wsp_getAllSubscrEligibility') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getAllSubscrEligibility
    IF OBJECT_ID('dbo.wsp_getAllSubscrEligibility') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getAllSubscrEligibility >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getAllSubscrEligibility >>>'
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
CREATE PROCEDURE dbo.wsp_getAllSubscrEligibility
AS
  BEGIN  
	SELECT 
          eligibilityId,
          subscriptionOfferId,
          localeId,
          cityId,
          jurisdictionId,
          secondJurisdictionId,
          countryId,
          billingLocationId,
          product,
          community,
          userType,
          brand,
          gender
        FROM SubscriptionEligibility
        ORDER BY subscriptionOfferId 
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getAllSubscrEligibility') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getAllSubscrEligibility >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getAllSubscrEligibility >>>'
go
GRANT EXECUTE ON dbo.wsp_getAllSubscrEligibility TO web
go

