USE Accounting
go
IF OBJECT_ID('dbo.wsp_getQuickBuySubs') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getQuickBuySubs
    IF OBJECT_ID('dbo.wsp_getQuickBuySubs') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getQuickBuySubs >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getQuickBuySubs >>>'
END
go
/******************************************************************************
** CREATION:
**   Author:      Mark Jaeckle
**   Date:        Feb 2011
**   Description: Get subscription QuickBuy record for specified user.  Excludes
**                upsells.
**  
**   Note: Cloned and then modified from wsp_getQuickBuyByUserId.
**
******************************************************************************/

CREATE PROCEDURE wsp_getQuickBuySubs
 @userId NUMERIC(12,0)
AS

DECLARE
 @maxDateCreated        DATETIME
,@subscriptionOfferId       SMALLINT
,@creditCardId          INT
,@subscriptionOfferDetailId SMALLINT
,@dateCreated           DATETIME
,@ordinal               TINYINT

BEGIN
    SELECT @subscriptionOfferId = subscriptionOfferId
      FROM UserAccount 
     WHERE userId = @userId

    SELECT @maxDateCreated = MAX(dateCreated) 
      FROM Purchase (INDEX XAK3Purchase) 
     WHERE userId = @userId 
       AND creditCardId > 0 
       AND cost > 0
       AND subscriptionOfferDetailId IN (SELECT subscriptionOfferDetailId FROM SubscriptionOfferDetail WHERE subscriptionOfferId = @subscriptionOfferId AND ordinal > 0 AND dateExpiry IS NULL AND masterOfferDetailId = 0)

    -- if previous purchase using default purchase offer, get last purchase details
    IF @maxDateCreated IS NOT NULL
        BEGIN
            SELECT creditCardId
                  ,subscriptionOfferDetailId
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
               AND subscriptionOfferDetailId IN (SELECT subscriptionOfferDetailId FROM SubscriptionOfferDetail WHERE ordinal > 0 AND dateExpiry IS NULL AND masterOfferDetailId = 0)  -- not web 900 purchase

            -- get last successful credit card purchase, we get ordinal of offer detail and map to current default
            -- for this user
            IF @maxDateCreated IS NOT NULL
                BEGIN
                    SELECT @creditCardId = creditCardId
                          ,@subscriptionOfferDetailId = subscriptionOfferDetailId
                          ,@dateCreated = dateCreated
                      FROM Purchase
                     WHERE userId = @userId
                       AND dateCreated = @maxDateCreated
                
                    IF @subscriptionOfferDetailId IS NOT NULL
                        BEGIN
                            SELECT @ordinal = ordinal
                              FROM SubscriptionOfferDetail
                             WHERE subscriptionOfferDetailId = @subscriptionOfferDetailId
                               AND dateExpiry IS NULL
                     
                            IF @ordinal IS NOT NULL
                                BEGIN
                                    SELECT @subscriptionOfferDetailId = subscriptionOfferDetailId 
                                      FROM SubscriptionOfferDetail
                                     WHERE subscriptionOfferId = @subscriptionOfferId
                                       AND ordinal = @ordinal
                                       AND dateExpiry IS NULL
                       
                                    SELECT @creditCardId
                                          ,@subscriptionOfferDetailId
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
EXEC sp_procxmode 'dbo.wsp_getQuickBuySubs','unchained'
go
IF OBJECT_ID('dbo.wsp_getQuickBuySubs') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getQuickBuySubs >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getQuickBuySubs >>>'
go
GRANT EXECUTE ON dbo.wsp_getQuickBuySubs TO web
go
