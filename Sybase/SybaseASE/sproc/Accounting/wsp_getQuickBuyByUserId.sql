IF OBJECT_ID('dbo.wsp_getQuickBuyByUserId') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getQuickBuyByUserId
    IF OBJECT_ID('dbo.wsp_getQuickBuyByUserId') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getQuickBuyByUserId >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getQuickBuyByUserId >>>'
END
go

/******************************************************************************
**
** CREATION:
**   Author:      Andy Tran
**   Date:        August 25, 2003
**   Description: get QuickBuy record
**
** REVISION(S):
**   Author:      Mike Stairs
**   Date:        November 26, 2003
**   Description: modified to return offerDetail mapped to current offer, if last
**                purchase was from different offer
**
**   Author:      Andy Tran
**   Date:        February 2006
**   Description: modified to exclude offer details that are already expired
**
******************************************************************************/

CREATE PROCEDURE wsp_getQuickBuyByUserId
 @userId NUMERIC(12,0)
AS

DECLARE
 @maxDateCreated        DATETIME
,@purchaseOfferId       SMALLINT
,@creditCardId          INT
,@purchaseOfferDetailId SMALLINT
,@dateCreated           DATETIME
,@ordinal               TINYINT

BEGIN
    SELECT @purchaseOfferId = purchaseOfferId
      FROM UserAccount 
     WHERE userId = @userId

    SELECT @maxDateCreated = MAX(dateCreated) 
      FROM Purchase (INDEX XAK3Purchase) 
     WHERE userId = @userId 
       AND creditCardId > 0 
       AND cost > 0
       AND purchaseOfferDetailId IN (SELECT purchaseOfferDetailId FROM PurchaseOfferDetail WHERE purchaseOfferId = @purchaseOfferId AND ordinal > 0 AND dateExpiry IS NULL)

    -- if previous purchase using default purchase offer, get last purchase details
    IF @maxDateCreated IS NOT NULL
        BEGIN
            SELECT creditCardId
                  ,purchaseOfferDetailId
                  ,dateCreated
              FROM Purchase
             WHERE userId = @userId
               AND dateCreated = @maxDateCreated
        END
    ELSE
        BEGIN
            SELECT @maxDateCreated = MAX(dateCreated) 
              FROM Purchase (INDEX XAK3Purchase) 
             WHERE userId = @userId 
               AND creditCardId > 0 
               AND cost > 0
               AND purchaseOfferDetailId IN (SELECT purchaseOfferDetailId FROM PurchaseOfferDetail WHERE ordinal > 0 AND dateExpiry IS NULL)  -- not web 900 purchase

            -- get last successful credit card purchase, we get ordinal of offer detail and map to current default
            -- for this user
            IF @maxDateCreated IS NOT NULL
                BEGIN
                    SELECT @creditCardId = creditCardId
                          ,@purchaseOfferDetailId = purchaseOfferDetailId
                          ,@dateCreated = dateCreated
                      FROM Purchase
                     WHERE userId = @userId
                       AND dateCreated = @maxDateCreated
                
                    IF @purchaseOfferDetailId IS NOT NULL
                        BEGIN
                            SELECT @ordinal = ordinal
                              FROM PurchaseOfferDetail
                             WHERE purchaseOfferDetailId = @purchaseOfferDetailId
                               AND dateExpiry IS NULL
                     
                            IF @ordinal IS NOT NULL
                                BEGIN
                                    SELECT @purchaseOfferDetailId = purchaseOfferDetailId 
                                      FROM PurchaseOfferDetail
                                     WHERE purchaseOfferId = @purchaseOfferId
                                       AND ordinal = @ordinal
                                       AND dateExpiry IS NULL
                       
                                    SELECT @creditCardId
                                          ,@purchaseOfferDetailId
                                          ,@dateCreated
                                END
                            ELSE
                                BEGIN 
                                    SELECT 1 WHERE 1 = 2
                                END
                        END
                    ELSE
                        BEGIN 
                            SELECT 1 WHERE 1 = 2
                        END
                END
            ELSE
                BEGIN 
                    SELECT 1 WHERE 1 = 2
                END
        END
        
    RETURN @@error
END
go

GRANT EXECUTE ON dbo.wsp_getQuickBuyByUserId TO web
go

IF OBJECT_ID('dbo.wsp_getQuickBuyByUserId') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getQuickBuyByUserId >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getQuickBuyByUserId >>>'
go
