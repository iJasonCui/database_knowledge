IF OBJECT_ID('dbo.wsp_getFirstPurchase') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getFirstPurchase
    IF OBJECT_ID('dbo.wsp_getFirstPurchase') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getFirstPurchase >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getFirstPurchase >>>'
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

CREATE PROCEDURE wsp_getFirstPurchase
 @userId 				NUMERIC(12,0),
 @localeId                              SMALLINT,
 @startDate                             DATETIME,
 @endDate                               DATETIME
AS


BEGIN
  SET ROWCOUNT 1
  SELECT credits,
         cost+tax,
         currencyCode,
         contentText         
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
  ORDER BY p.dateCreated ASC
  AT ISOLATION READ UNCOMMITTED
  
  RETURN @@error

END
go
GRANT EXECUTE ON dbo.wsp_getFirstPurchase TO web
go
IF OBJECT_ID('dbo.wsp_getFirstPurchase') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getFirstPurchase >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getFirstPurchase >>>'
go


