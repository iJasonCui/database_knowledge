#!/bin/bash

if [ $# -ne 1 ]
then 
   echo "Usage: ${0} <ReportDate>, for instance, ${0} 20051001 "
   exit 1 
else 
   ReportDate=${1}
fi

UserName=cron_sa
DestServerName=IQDB1
DestPassword=`cat $HOME/.sybpwd | grep -w ${DestServerName} | awk '{print $2}'`

SourceServerName=webdb0r
SourcePassword=`cat $HOME/.sybpwd | grep -w ${SourceServerName} | awk '{print $2}'`

WorkDir=/data/scripts/DeferredRevenue/
ProcessedDate=`date '+%Y%m%d_%H%M%S'`
LogFile=./output/${0}.${ReportDate}.log.${ServerName}.${ProcessedDate}

date > ${LogFile}

echo "=================================" >> ${LogFile}
echo "Step 1: figure out the report cut off date (Year and month) " >> ${LogFile} 
  
sqsh -U${UserName} -S${SourceServerName} -P${SourcePassword}  << EOQ1 >> ${LogFile}

DECLARE  @RepDate        datetime
DECLARE  @RepMon         char(3)
DECLARE  @RepYear        char(4)
DECLARE  @lastYear       char(4)
DECLARE  @StartDateTime  datetime
DECLARE  @EndDateTime    datetime
DECLARE  @returnMessage  varchar(250)

select  @RepDate = convert(datetime, convert(varchar(10),${ReportDate}) )
select  @RepMon  = substring(datename(mm,@RepDate),1,3)
select  @RepYear = convert(char(4),datename(yy, @RepDate))
select  @lastYear= convert(char(4),datename(yy, dateadd(yy,-1,@RepDate))) 
select  @StartDateTime = convert(datetime, @RepMon + " 01 " + @lastYear)
select  @EndDateTime   = convert(datetime, @RepMon + " 01 " + @RepYear)

select  @returnMessage = "[RepMon] " + @RepMon
print   @returnMessage
select  @returnMessage = "[RepYear] " + @RepYear
print   @returnMessage
go

EOQ1

RepMon=`cat ${LogFile} | grep RepMon | awk '{print $2}'`
RepYear=`cat ${LogFile} | grep RepYear | awk '{print $2}'`


echo "=================================" >> ${LogFile}
echo "Step 2: retrieve Banned user from source server to Destination server  " >> ${LogFile}

if [ -f ${WorkDir}/v_BannedUser.out.${ReportDate} ]
then
   echo "${WorkDir}/v_BannedUser.out.${ReportDate} already exists, does not need to bcp" >> ${LogFile}
else

sqsh -U${UserName} -S${SourceServerName} -P${SourcePassword}  << EOQ2 >> ${LogFile}

IF OBJECT_ID('dbo.v_BannedUser') IS NOT NULL
BEGIN
    DROP VIEW dbo.v_BannedUser
    IF OBJECT_ID('dbo.v_BannedUser') IS NOT NULL
        PRINT '<<< FAILED DROPPING VIEW dbo.v_BannedUser >>>'
    ELSE
        PRINT '<<< DROPPED VIEW dbo.v_BannedUser >>>'
END
go
create view v_BannedUser as
select user_id as userId, status
from Member..user_info where status is null or status in ('Y', 'V', 'S')
go
IF OBJECT_ID('dbo.v_BannedUser') IS NOT NULL
    PRINT '<<< CREATED VIEW dbo.v_BannedUser >>>'
ELSE
    PRINT '<<< FAILED CREATING VIEW dbo.v_BannedUser >>>'
go

EOQ2

bcp Member..v_BannedUser out ${WorkDir}/v_BannedUser.out.${ReportDate} -U${UserName} -P${SourcePassword} -S${SourceServerName} \
     -c -t"|" -r"|\n" -e v_BannedUser.bcperr.out 

if [ -f v_BannedUser.bcperr.out ]
then 
   echo "bcp out Member..v_BannedUser error, skip the rest steps"
   exit 2
fi

fi


isql -U${UserName} -S${DestServerName} -P${DestPassword}  << EOQ21 >> ${LogFile}

IF OBJECT_ID('DeferredRev.BannedUser${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.BannedUser${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.BannedUser${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.BannedUser${RepMon}${RepYear}
(
    userId                 numeric(12,0) NOT NULL,
    status                 char(1)       NULL
)
go

SET OPTION cron_sa.CONVERSION_ERROR=OFF
go
LOAD TABLE DeferredRev.BannedUser${RepMon}${RepYear} 
(
     userId ,
     status         
)
from '${WorkDir}/v_BannedUser.out.${ReportDate}'
DELIMITED BY '|'
QUOTES OFF
ESCAPES OFF
IGNORE CONSTRAINT UNIQUE 0, NULL 0, DATA VALUE 0 
WITH CHECKPOINT ON 
go
select count(*) from DeferredRev.BannedUser${RepMon}${RepYear} 
go

CREATE UNIQUE NONCLUSTERED INDEX idx_userId ON DeferredRev.BannedUser${RepMon}${RepYear}(userId) 
go

EOQ21

echo "=================================" >> ${LogFile}
echo "Step 3: generate the outstanding balance report as of ${RepDate}  " >> ${LogFile}

isql -U${UserName} -S${DestServerName} -P${DestPassword}  << EOQ3 >> ${LogFile}

PRINT "Step 3.1 -- CREATE TABLE DeferredRev.OutstandingBalance${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.OutstandingBalance${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.OutstandingBalance${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.OutstandingBalance${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.OutstandingBalance${RepMon}${RepYear}
(
    userId                                numeric(12,0) NOT NULL,
    balance${RepMon}${RepYear}            int           NULL,
    dateLastPurchased${RepMon}${RepYear}  datetime      NULL,      
    dateLastPurchased                     datetime      NULL
)
go

PRINT "Step 3.2 -- CREATE TABLE DeferredRev.OutstandingBal${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.OutstandingBal${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.OutstandingBal${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.OutstandingBal${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.OutstandingBal${RepMon}${RepYear}
(
    userId                                numeric(12,0) NOT NULL,
    balance${RepMon}${RepYear}            int           NULL
)
go

PRINT "Step 3.3 -- CREATE TABLE DeferredRev.OBLastTranDate${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.OBLastTranDate${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.OBLastTranDate${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.OBLastTranDate${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.OBLastTranDate${RepMon}${RepYear}
(
    userId                                numeric(12,0) NOT NULL,
    dateLastPurchased${RepMon}${RepYear}  datetime      NULL,    
    dateLastPurchased                     datetime      NULL
)
go

PRINT "Step 3.4 -- populate data on OutstandingBal${RepMon}${RepYear} "

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))
 
INSERT DeferredRev.OutstandingBal${RepMon}${RepYear}
(
    userId      ,
    balance${RepMon}${RepYear} 
)
SELECT 
    userId,                                                     
    SUM(CASE WHEN dateCreated < @RepDate THEN credits ELSE 0 END) as balance${RepMon}${RepYear}
FROM DeferredRev.AccountTransaction       
--WHERE batchId > 0 and creditTypeId = 1 and xactionTypeId in (1,2,3,4,6,21,22,23,24,25,26,28) 
WHERE creditTypeId = 1 and xactionTypeId in (1,2,3,4,6,21,22,23,24,25,26,28)
GROUP BY userId
go

PRINT "Step 3.5 -- populate data on DeferredRev.OBLastTranDate${RepMon}${RepYear} "

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

INSERT DeferredRev.OBLastTranDate${RepMon}${RepYear}
(
    userId      ,
    dateLastPurchased${RepMon}${RepYear},
    dateLastPurchased
)
SELECT
    userId,
    MAX(CASE WHEN dateCreated < @RepDate THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurchased${RepMon}${RepYear},
    MAX(dateCreated) AS dateLastPurchased
FROM DeferredRev.Purchase
WHERE xactionTypeId = 6 -- and creditTypeId = 1 --only when use DeferredRev.AccountTransaction
GROUP BY userId
go

PRINT "Step 3.5 -- populate data on DeferredRev.OutstandingBalance${RepMon}${RepYear}"

INSERT DeferredRev.OutstandingBalance${RepMon}${RepYear}
(
    userId      ,
    balance${RepMon}${RepYear} ,
    dateLastPurchased${RepMon}${RepYear},
    dateLastPurchased
)
SELECT 
    b.userId,
    b.balance${RepMon}${RepYear} ,
    l.dateLastPurchased${RepMon}${RepYear},
    l.dateLastPurchased
FROM  DeferredRev.OutstandingBal${RepMon}${RepYear} b, DeferredRev.OBLastTranDate${RepMon}${RepYear} l 
WHERE b.userId = l.userId and b.balance${RepMon}${RepYear} > 0 and b.balance${RepMon}${RepYear} <= 500 
go

--    creditTypeId = 1 -- regular credit                                                        
--    and xactionTypeId in (1,2,3,4,6,21,22,23,24,25,26,28) -- 1-4,21-26,28 are consumption, 6 is purchase    

/*
ctionTypeId   description
1       IM BASIC
2       IM DOUBLE
3       MAIL
4       COLLECT MAIL
5       balance
6       purchase
7       declined
8       charge back
9       credit (reversal)
10      void (same-day reversal)
11      expiry
12      admin adjustment
13      downtime compensation
14      USI promo
15      admin compensation
16      VIDEO MAIL
17      COLLECT VIDEO MAIL
18      processor refused
19      processor cancelled
20      processor charged back
21      IM extended session 1 minute fro
22      IM extended session 2 minutes fr
23      IM extended session 5 minutes fr
24      IM extended session 1 minute fro
25      IM extended session 2 minutes fr
26      IM extended session 5 minutes fr
28      PARTY 20 minutes IM session
29      UK Free Trial
30      Subscription Promo
31      Subscription Purchase
32      Subscription Renewal
*/

PRINT "Step 3.6 --delete Banned User "

delete from DeferredRev.OutstandingBalance${RepMon}${RepYear}  
where userId in (select userId from DeferredRev.BannedUser${RepMon}${RepYear} )
go

PRINT "Step 3.7 -- print out the OutstandingBalance report "


DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

select  
    sum(balance${RepMon}${RepYear}) as TotalBalance${RepMon}${RepYear}
from DeferredRev.OutstandingBalance${RepMon}${RepYear}

select   
    datepart(yy,dateLastPurchased${RepMon}${RepYear}) * 100 + datepart(mm,dateLastPurchased${RepMon}${RepYear}) 
         as dateLastPur${RepMon}${RepYear}, 
    sum(balance${RepMon}${RepYear}) as TotalBalance${RepMon}${RepYear},
    sum(CASE WHEN dateLastPurchased >= @RepDate THEN balance${RepMon}${RepYear} ELSE 0 END),
    sum(CASE WHEN dateLastPurchased <  @RepDate THEN balance${RepMon}${RepYear} ELSE 0 END)      
from DeferredRev.OutstandingBalance${RepMon}${RepYear} 
group by datepart(yy,dateLastPurchased${RepMon}${RepYear}) * 100 + datepart(mm,dateLastPurchased${RepMon}${RepYear})
order by datepart(yy,dateLastPurchased${RepMon}${RepYear}) * 100 + datepart(mm,dateLastPurchased${RepMon}${RepYear})
go

--delete from WebDeferredRev..temp_jason_OutstandingBal  
--where userId not in (select userId from WebDeferredRev..temp_jason_PositiveChart) --13010
--delete from WebDeferredRev..temp_jason_PositiveChart 
--where userId not in (select userId from WebDeferredRev..temp_jason_OutstandingBal  ) --1233

EOQ3

exit 0


