IF OBJECT_ID('dbo.wsp_getRenewalEmailList') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.wsp_getRenewalEmailList
    IF OBJECT_ID('dbo.wsp_getRenewalEmailList') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.wsp_getRenewalEmailList >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.wsp_getRenewalEmailList >>>'
END
go
/******************************************************************************
        This procs is only for new subscription offer from 18 to 23
        So for production we need following line 
        --AND subscriptionOfferDetailId between 18 and 23 
        --AND dateCreated>'March 1, 2007'
******************************************************************************/
CREATE PROCEDURE dbo.wsp_getRenewalEmailList
    @lastUserId                    INT,
    @blockSize                     INT,
    @day                           INT
AS

  BEGIN  

declare @now  DATETIME

 SET ROWCOUNT  @blockSize
EXEC wsp_GetDateGMT @now OUTPUT

/*
  	    SELECT  userId, subscriptionEndDate
        FROM UserSubscriptionAccount u
        WHERE 
        subscriptionStatus = 'I' AND 
        autoRenew='N' AND 
        subscriptionOfferDetailId between 18 and 23 AND 
        dateCreated>'March 13, 2007' AND 
        userId > @lastUserId AND 
        datediff(day, subscriptionEndDate, @now) >= @day AND 
           (not exists (select 1 from RenewalEmailLog where userId = u.userId) OR 
                exists (select 1 from RenewalEmailLog where userId = u.userId and counter<3 and u.subscriptionEndDate > subscriptionEndDate))
        ORDER BY userId 

*/

  	  SELECT  u.userId, u.subscriptionEndDate
        FROM UserSubscriptionAccount u  ( INDEX XPKUserSubscriptionAccount)
        WHERE 
              u.subscriptionStatus = 'I' AND 
              u.autoRenew='N' AND 
              u.subscriptionOfferDetailId between 18 and 23 AND 
              u.dateCreated>'March 13, 2007' AND 
              u.userId > @lastUserId AND 
              u.subscriptionEndDate < dateadd(day, -@day, @now) AND 
                   (not exists (select 1 from RenewalEmailLog r where userId = u.userId and userId > @lastUserId and r.subscriptionEndDate < dateadd(day, -@day, @now) ) OR 
                exists (select 1 from RenewalEmailLog r where userId = u.userId and counter<3 and r.subscriptionEndDate < u.subscriptionEndDate and r.subscriptionEndDate < dateadd(day, -@day, @now) and userId > @lastUserId))
        ORDER BY userId 
        
END

go
EXEC sp_procxmode 'dbo.wsp_getRenewalEmailList','unchained'
go
IF OBJECT_ID('dbo.wsp_getRenewalEmailList') IS NOT NULL
    PRINT '<<< CREATED PROCEDURE dbo.wsp_getRenewalEmailList >>>'
ELSE
    PRINT '<<< FAILED CREATING PROCEDURE dbo.wsp_getRenewalEmailList >>>'
go
GRANT EXECUTE ON dbo.wsp_getRenewalEmailList TO web
go

