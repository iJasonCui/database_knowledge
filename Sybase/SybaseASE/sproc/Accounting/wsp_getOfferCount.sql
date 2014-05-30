IF OBJECT_ID('dbo.wsp_getOfferCount') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getOfferCount
    IF OBJECT_ID('dbo.wsp_getOfferCount') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getOfferCount >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getOfferCount >>>'
END
go
/******************************************************************************
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getOfferCount
@offerId int,
@offerType char(1)
AS

BEGIN  
   SELECT offerCount 
   FROM OfferCounter 
   WHERE offerId = @offerId
     AND offerType = @offerType

   RETURN @@error
END
go

IF OBJECT_ID('dbo.wsp_getOfferCount') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getOfferCount >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getOfferCount >>>'
go

GRANT EXECUTE ON dbo.wsp_getOfferCount TO web
go
