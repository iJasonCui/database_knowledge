IF OBJECT_ID('dbo.wsp_updOfferCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_updOfferCount
    IF OBJECT_ID('dbo.wsp_updOfferCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_updOfferCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_updOfferCount >>>'
END
go
/******************************************************************************
******************************************************************************/
CREATE PROCEDURE dbo.wsp_updOfferCount
@offerId int,
@offerType char(1)
AS

BEGIN  
   UPDATE OfferCounter 
      SET offerCount = offerCount +  1
   WHERE offerId = @offerId
     AND offerType = @offerType

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_updOfferCount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_updOfferCount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_updOfferCount >>>'
go

GRANT EXECUTE ON dbo.wsp_updOfferCount TO web
go
