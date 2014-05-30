IF OBJECT_ID('dbo.wsp_getSubEligByOfferId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getSubEligByOfferId
    IF OBJECT_ID('dbo.wsp_getSubEligByOfferId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getSubEligByOfferId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getSubEligByOfferId >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Marc Henderson
**   Date:  December 2004
**   Description:  retrieves all subscription types by offerId
**
**
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getSubEligByOfferId
@subscriptionOfferId int
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
        WHERE subscriptionOfferId = @subscriptionOfferId
     RETURN @@error
  END
go
IF OBJECT_ID('dbo.wsp_getSubEligByOfferId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getSubEligByOfferId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getSubEligByOfferId >>>'
go
GRANT EXECUTE ON dbo.wsp_getSubEligByOfferId TO web
go

