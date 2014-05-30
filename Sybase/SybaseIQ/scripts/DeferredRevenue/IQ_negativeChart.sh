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
echo "Step 3: generate the Negative chart as of ${ReportDate}  " >> ${LogFile}

#-------------------------------------------#
# generate the sql statement to create table 
#-------------------------------------------#

echo "Step 3.1: create table DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear} " >> ${LogFile}

SQL_FileName=create_table_NegativeChartCreditUsed${RepMon}${RepYear}.sql

sqsh -U${UserName} -S${SourceServerName} -P${SourcePassword}  << EOQ31 > ${SQL_FileName}

set nocount on
DECLARE @startDate datetime
DECLARE @month  char(3)
DECLARE @year   char(4)
DECLARE @return_result varchar(250)
DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

print  "IF OBJECT_ID('DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear}') IS NOT NULL" 
print  "BEGIN" 
print  "   DROP TABLE DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear}" 
print  "END"   
print  "ELSE BEGIN" 
print  "   PRINT 'THERE IS NO TABLE DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear}' " 
print  "END"   
print  "go"    

--create table script
select @startDate = 'Jan 1 2003'

print "CREATE TABLE DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear} "
print "("
print "  userId numeric(12,0) NOT NULL"

while @startDate < @RepDate 
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", creditConsumed" + @year + @month + " int NULL" 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

print ")"
print "go"

--insert clause
select @startDate = 'Jan 1 2003'

select @return_result = "DECLARE @RepDate  datetime"
print @return_result
select @return_result = "SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))"
print @return_result
select @return_result = "INSERT DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear} " 
print @return_result
select @return_result = "("
print @return_result
select @return_result = "  userId "
print @return_result

while @startDate < @RepDate 
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", creditConsumed" + @year + @month 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

select @return_result = ")"
print @return_result

--select clause
select @startDate = 'Jan 1 2003'

select @return_result = "SELECT a.userId" 
print @return_result

while @startDate < @RepDate 
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", SUM(CASE WHEN a.dateCreated >= dateadd(mm,0," + "'" + convert(varchar(12),@startDate,107) +"')" 
        + " and a.dateCreated < dateadd(mm,1," + "'" + convert(varchar(12),@startDate,107) +"')"
        + " THEN a.credits ELSE 0 END) AS creditConsumed" + @year + @month 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

print "FROM DeferredRev.AccountTransaction a"
print "WHERE a.creditTypeId = 1 -- regular credit "
---print "    and a.xactionTypeId >= 1 and a.xactionTypeId <= 4 --consumption"
print "    and a.xactionTypeId in (1,2,3,4,21,22,23,24,25,26,28) --consumption" 
print "    and a.dateCreated < @RepDate"
print "GROUP BY a.userId "
print "go"
print "SELECT COUNT(*) FROM DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear}"
print "go"
go

EOQ31

isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}

###  echo "Step 3.2: create table DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear} " >> ${LogFile}

isql -U${UserName} -S${DestServerName} -P${DestPassword} << EOQ32 >> ${LogFile}

PRINT "Step 3.2: create table DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}
(
     userId                 numeric(12,0) NOT NULL
   , dateFirstPurchased      datetime      NULL
)
go

print "Step 3.3 -- populate data into DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear} "  

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

INSERT DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}
(
    userId      ,
    dateFirstPurchased
)
SELECT
    userId,
    Min(dateCreated) AS dateFirstPurchased
FROM DeferredRev.AccountTransaction
WHERE xactionTypeId = 6 and creditTypeId = 1 and  dateCreated < @RepDate 
--and dateCreated >= "Nov 12 2002"
GROUP BY userId
go


PRINT "Step 3.4 --delete Banned User "

delete from DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear}  
where userId in (select userId from DeferredRev.BannedUser${RepMon}${RepYear} )
go
/*
public final static String UNDERAGE_MEMBER_STATUS = "Y";
public final static String INACTIVE_MEMBER_STATUS = "I";
public final static String BANNED_MEMBER_STATUS = "V";
public final static String SUSPENDED_MEMBER_STATUS = "S";
public final static String DELETED_MEMBER_STATUS1 = "I";
public final static String DELETED_MEMBER_STATUS2 = "J";
public final static String ACTIVE_MEMBER_STATUS = "A";
public final static String WRONG_GENDER_STATUS = "G";
public final static String INACTIVE_EMAIL_VERIFY_STATUS = "E";
*/


EOQ32

#-----------------------------------------------#
# generate the sql for insert DeferredRev.NegativeChart${RepMon}${RepYear} 
#-----------------------------------------------#

SQL_FileName=insert_table_NegativeChart.sql

sqsh -U${UserName} -S${SourceServerName} -P${SourcePassword}  << EOQ33 > ${SQL_FileName}

set nocount on
DECLARE @startDate datetime
DECLARE @month  char(3)
DECLARE @year   char(4)
DECLARE @return_result varchar(250)
DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

print  "IF OBJECT_ID('DeferredRev.NegativeChart${RepMon}${RepYear}') IS NOT NULL" 
print  "BEGIN" 
print  "   DROP TABLE DeferredRev.NegativeChart${RepMon}${RepYear}" 
print  "END"   
print  "ELSE BEGIN" 
print  "   PRINT 'THERE IS NO TABLE DeferredRev.NegativeChart${RepMon}${RepYear}' " 
print  "END"   
print  "go"    

--create table script
select @startDate = 'Jan 1 2003'

print "CREATE TABLE DeferredRev.NegativeChart${RepMon}${RepYear} " 
print "("
print "  userId                  numeric(12,0) NOT NULL"
print ", dateFirstPurchased      datetime      NULL" 

while @startDate < @RepDate
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", creditConsumed" + @year + @month + " int NULL" 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

select @return_result = ")"
print @return_result
select @return_result = "go"
print @return_result

--insert clause
select @startDate = 'Jan 1 2003'

print "DECLARE @RepDate  datetime"
print "SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))"
print "INSERT DeferredRev.NegativeChart${RepMon}${RepYear} " 
print "("
print "  userId "
print ", dateFirstPurchased" 

while @startDate < @RepDate 
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", creditConsumed" + @year + @month 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

select @return_result = ")"
print @return_result

--select clause
select @startDate = 'Jan 1 2003'

print "SELECT  a.userId" 
print "      , a.dateFirstPurchased" 

while @startDate < @RepDate 
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = ", b.creditConsumed" + @year + @month 

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end
print "FROM DeferredRev.NegativeChartFirstPurchase${RepMon}${RepYear} a , DeferredRev.NegativeChartCreditUsed${RepMon}${RepYear} b" 
print "WHERE a.userId = b.userId "
print "go"
print "SELECT COUNT(*) FROM DeferredRev.NegativeChart${RepMon}${RepYear}"
print "go"
go

EOQ33

echo "Step 3.5 --populate data into DeferredRev.NegativeChart${RepMon}${RepYear} " >> ${LogFile}

isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}

echo "well done "  >> ${LogFile} 

cat ${LogFile}

exit 0


