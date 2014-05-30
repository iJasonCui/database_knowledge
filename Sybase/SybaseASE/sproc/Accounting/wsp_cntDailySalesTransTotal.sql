IF OBJECT_ID('dbo.wsp_cntDailySalesTransTotal') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_cntDailySalesTransTotal
    IF OBJECT_ID('dbo.wsp_cntDailySalesTransTotal') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_cntDailySalesTransTotal >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_cntDailySalesTransTotal >>>'
END
go
/******************************************************************************
**
** CREATION:
**   Author:  Mike Stairs
**   Date:  October 2003
**   Description:  
**
** REVISION(S):
**   Author: Yan Liu and Jason Cui 
**   Date:  Jul 21 2004 
**   Description: 6-- purchase; 8--charge back; 9--credit(reversal); 12--admin adjustment; 47-- subscription reactivation
**
** REVISION(S):
**   Author: Yan Liu 
**   Date:  Jul 23 2004 
**   Description: To keep daily stats and scoreboard in sync (report purchase only).
**
** REVISION(S):
**   Author: Yadira Genoves 
**   Date:  Aug 18 2008
**   Description: Select Lavalife's sales. productId = (0 -- Lavalife, 1 -- Prime, 2 -- 50+)
**
******************************************************************************/

CREATE PROCEDURE wsp_cntDailySalesTransTotal
    @fromDate DATETIME,
    @toDate   DATETIME
AS

 SELECT SUM(costUSD), 
       COUNT(*)
  FROM BillingLocation billingLoc, Purchase purchase
 WHERE billingLoc.billingLocationId = purchase.billingLocationId
  --AND billingLoc.productId = 0
  AND purchase.dateCreated >= @fromDate  
  AND purchase.dateCreated <  @toDate 
  AND purchase.xactionTypeId IN (6, 31, 32, 47, 55, 56, 59 )  

RETURN @@error
go

GRANT EXECUTE ON dbo.wsp_cntDailySalesTransTotal TO web
go

IF OBJECT_ID('dbo.wsp_cntDailySalesTransTotal') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_cntDailySalesTransTotal >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_cntDailySalesTransTotal >>>'
go
