#!/bin/bash

. /opt/etc/sybase12_5/.bash_profile

############################################################################
# Function : Calculate the monthly Web Deferred Revenue 
# Usage: ./crontab-web-DR.sh "May 1 2001 0:00:00" "April 30 2002 23:59:59"
# Previous step: crontab-web-DR-bcp.sh
# Next step: web-dr-monthly.sql 
############################################################################

Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`

cd /opt/etc/sybase/maint/deferred-revenue

date > cron-web-DR.log

isql -Usa -P${Password} -Swebdb0r >> cron-web-DR.log <<EOF2
set nocount on
go

select getdate()
use WebDeferredRev
go

print "--------drop table temp_account_request"
DROP TABLE temp_account_request
go

print "--------drop table temp_Balance_WEB"
select getdate()
DROP TABLE temp_Balance_WEB
go

print "--------drop table temp_account_request_S"
DROP TABLE temp_account_request_S
go

print "--------drop table temp_Balance_WEB_S"
select getdate()
DROP TABLE temp_Balance_WEB_S
go

print "--------select data into temp_account_request"
DECLARE  @currentMon	 char(3)
DECLARE  @currentYear    char(4)
DECLARE  @lastYear       char(4)
DECLARE  @StartDateTime  datetime
DECLARE  @EndDateTime    datetime  
DECLARE  @returnMessage  varchar(250)

select  @currentMon = substring(datename(mm,getdate()),1,3)
select  @currentYear= convert(char(4),datename(yy,getdate()))
select  @lastYear= convert(char(4),datename(yy,dateadd(yy,-3,getdate()))) --was 1 year back, now is 3 years back
select  @StartDateTime = convert(datetime, @currentMon + " 01 " + @lastYear)
select  @EndDateTime = convert(datetime, @currentMon + " 01 " + @currentYear)

select  @returnMessage = "[currentMon] " + @currentMon
print   @returnMessage
select  @returnMessage = "[currentYear] " + @currentYear
print   @returnMessage

--Part 1: for regular credit 

SELECT p.userId as customerId,
    sum(po.credits) as unitQty,
    convert(numeric(12,2),sum(p.costUSD + p.taxUSD)) as totalPrice,
--	100 * datepart(yy,Min(p.dateCreated)) + datepart(mm,Min(p.dateCreated)) as firstTranYearMonth,
    100 * datepart(yy,Max(p.dateCreated)) + datepart(mm,Max(p.dateCreated)) as lastTranYearMonth
INTO temp_account_request
FROM arch_Accounting..Purchase p, arch_Accounting..PurchaseOfferDetail po  
WHERE p.dateCreated >= @StartDateTime and p.dateCreated < @EndDateTime and p.xactionTypeId = 6  
	and p.purchaseOfferDetailId = po.purchaseOfferDetailId	
GROUP BY userId

print "--------select data into temp_Balance_WEB "
SELECT userId as customerId, SUM(convert(int,credits)) as unitBalance
INTO temp_Balance_WEB
FROM DoNotDrop..CreditBalance
WHERE --dateModified < @EndDateTime and 
creditTypeId = 1 and userId > 0 and credits > 0 
GROUP BY userId

SELECT getdate()
go

IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_Balance_WEB') AND name='index_user_id')
BEGIN
    DROP INDEX temp_Balance_WEB.index_user_id
    IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_Balance_WEB') AND name='index_user_id')
        PRINT '<<< FAILED DROPPING INDEX temp_Balance_WEB.index_user_id >>>'
    ELSE
        PRINT '<<< DROPPED INDEX temp_Balance_WEB.index_user_id >>>'
END
go
CREATE UNIQUE NONCLUSTERED INDEX index_user_id
    ON dbo.temp_Balance_WEB(customerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_Balance_WEB') AND name='index_user_id')
    PRINT '<<< CREATED INDEX dbo.temp_Balance_WEB.index_user_id >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.temp_Balance_WEB.index_user_id >>>'
go

IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_account_request') AND name='index_user_id')
BEGIN
    DROP INDEX temp_account_request.index_user_id
    IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_account_request') AND name='index_user_id')
        PRINT '<<< FAILED DROPPING INDEX temp_account_request.index_user_id >>>'
    ELSE
        PRINT '<<< DROPPED INDEX temp_account_request.index_user_id >>>'
END
go
CREATE UNIQUE NONCLUSTERED INDEX index_user_id
    ON dbo.temp_account_request(customerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_account_request') AND name='index_user_id')
    PRINT '<<< CREATED INDEX dbo.temp_account_request.index_user_id >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.temp_account_request.index_user_id >>>'
go

select getdate()
go

--Part 2: for subscription project
print "--Part 2: for subscription project"

DECLARE  @currentMon     char(3)
DECLARE  @currentYear    char(4)
DECLARE  @lastYear       char(4)
DECLARE  @StartDateTime  datetime
DECLARE  @EndDateTime    datetime
DECLARE  @returnMessage  varchar(250)

select  @currentMon = substring(datename(mm,getdate()),1,3)
select  @currentYear= convert(char(4),datename(yy,getdate()))
select  @lastYear= convert(char(4),datename(yy,dateadd(yy,-1,getdate()))) 
select  @StartDateTime = convert(datetime, @currentMon + " 01 " + @lastYear)
select  @EndDateTime = convert(datetime, @currentMon + " 01 " + @currentYear)


SELECT p.userId as customerId,
    sum(po.duration) as unitQty,
    convert(numeric(12,2),sum(p.costUSD + p.taxUSD)) as totalPrice,
    100 * datepart(yy,Max(p.dateCreated)) + datepart(mm,Max(p.dateCreated)) as lastTranYearMonth
INTO temp_account_request_S
FROM arch_Accounting..Purchase p, arch_Accounting..SubscriptionOfferDetail po
WHERE p.dateCreated >= @StartDateTime and p.dateCreated < @EndDateTime  
 and  (p.xactionTypeId = 31 or p.xactionTypeId = 32)
 and  p.subscriptionOfferDetailId = po.subscriptionOfferDetailId
GROUP BY userId

SELECT u.userId as customerId, SUM(datediff(dd, @EndDateTime, u.subscriptionEndDate)) as unitBalance
INTO temp_Balance_WEB_S
--FROM arch_Accounting..UserSubscriptionAccount
FROM DoNotDrop..UserSubscriptionAccount u
WHERE u.subscriptionEndDate > @EndDateTime     
  and u.dateModified < @EndDateTime       
  and u.subscriptionStatus = "A"
  and u.userId > 0
  and u.subscriptionOfferDetailId not in (select subscriptionOfferDetailId 
                                            from arch_Accounting..SubscriptionOfferDetail where cost=0)
GROUP BY u.userId
go

SELECT getdate()
go

EOF2


#################### step 2: calculate the deferred revenue ###
currentMon=`cat cron-web-DR.log | grep currentMon | awk '{print $2}'`
currentYear=`cat cron-web-DR.log | grep currentYear | awk '{print $2}'`

isql -Usa -P${Password} >> cron-web-DR.log <<EOF3
select getdate()
use WebDeferredRev
go

--Part 1 : regular credit 
print "--Part 1 : regular credit"
print "drop tables "

drop table temp_dr_web_${currentMon}${currentYear}
go
drop table DeferredRevenue${currentMon}${currentYear}_last
go
drop table temp_Balance_WEB_${currentMon}${currentYear}
go

select * 
into temp_Balance_WEB_${currentMon}${currentYear} 
from temp_Balance_WEB
go

select b.customerId, a.unitQty, a.totalPrice, a.lastTranYearMonth, b.unitBalance
into temp_dr_web_${currentMon}${currentYear}
from temp_account_request a, temp_Balance_WEB b
where b.customerId *= a.customerId
go

declare @avgPrice  numeric(5,2)
select  @avgPrice = round(sum(isnull(totalPrice,2))/sum(isnull(unitQty,0)),2)
from temp_dr_web_${currentMon}${currentYear} 

print "======= aging by last purchase transaction ===================="
select lastTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*@avgPrice as deferredRevenue
into DeferredRevenue${currentMon}${currentYear}_last
from temp_dr_web_${currentMon}${currentYear}
where unitBalance > 0
group by lastTranYearMonth

select lastTranYearMonth,balance, @avgPrice as price, deferredRevenue from DeferredRevenue${currentMon}${currentYear}_last
go

select getdate()
go

--Part2 : subscription
print "--Part2 : subscription"
drop table temp_dr_web_${currentMon}${currentYear}_S
go
drop table DeferredRevenue${currentMon}${currentYear}_last_S
go
drop table temp_Balance_WEB_${currentMon}${currentYear}_S
go

select *
into temp_Balance_WEB_${currentMon}${currentYear}_S
from temp_Balance_WEB_S
go

select b.customerId, a.unitQty, a.totalPrice, a.lastTranYearMonth, b.unitBalance
into temp_dr_web_${currentMon}${currentYear}_S
from temp_account_request_S a, temp_Balance_WEB_S b
where b.customerId *= a.customerId
go

declare @avgPrice  numeric(5,2)
select  @avgPrice = round(sum(isnull(totalPrice,2))/sum(isnull(unitQty,0)),2)
from temp_dr_web_${currentMon}${currentYear}_S

print "======= aging by last purchase transaction ===================="
select lastTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*@avgPrice as deferredRevenue
into DeferredRevenue${currentMon}${currentYear}_last_S
from temp_dr_web_${currentMon}${currentYear}_S
where unitBalance > 0
group by lastTranYearMonth

select lastTranYearMonth,balance, @avgPrice as price, deferredRevenue from DeferredRevenue${currentMon}${currentYear}_last_S
go

select getdate()
go


EOF3

mailTitle="well done for deferred revenue of web "${currentMon}" "${currentYear}

mail -s "$mailTitle" jason.cui@lavalife.com,harry.helal@lavalife.com < cron-web-DR.log

exit 0

