IF OBJECT_ID('dbo.wsp_getFirstNonWebPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFirstNonWebPurchase
    IF OBJECT_ID('dbo.wsp_getFirstNonWebPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFirstNonWebPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFirstNonWebPurchase >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  September 2003
**   Description:  
**
** REVISION(S):
**   Author:
**   Date:
**   Description:
**
******************************************************************************/

CREATE PROCEDURE wsp_getFirstNonWebPurchase
 @userId 				NUMERIC(12,0),
 @localeId                              SMALLINT,
 @startDate                             DATETIME,
 @endDate                               DATETIME
AS

DECLARE @minCost NUMERIC(10,3)

BEGIN
  
  SELECT @minCost = min(p.cost) 
  FROM UserAccount u, PurchaseOfferDetail p
  WHERE
    u.userId = @userId AND
    u.purchaseOfferId = p.purchaseOfferId 
  
  SET ROWCOUNT 1
  SELECT credits,
         cost+tax,
         currencyCode,
         contentText,
         @minCost
  FROM Purchase p, AccountTransaction a , Currency c, LocaleContent l
  WHERE p.userId = @userId
  AND p.userId = a.userId
  AND p.currencyId = c.currencyId
  AND l.localeId = @localeId
  AND a.contentId = l.contentId
  AND p.dateCreated >= @startDate
  AND p.dateCreated <= @endDate
  AND cost > 0
  AND p.xactionTypeId = 6  -- must be a purchase
  AND p.purchaseTypeId != 1  -- not a web credit card purchase
  ORDER BY p.dateCreated ASC
  AT ISOLATION READ UNCOMMITTED
  
  RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getFirstNonWebPurchase TO web
go
IF OBJECT_ID('dbo.wsp_getFirstNonWebPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFirstNonWebPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFirstNonWebPurchase >>>'
go

