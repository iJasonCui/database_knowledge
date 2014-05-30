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
use Member
go

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
echo "Step 3: generate the outstanding balance report as of ${ReportDate}  " >> ${LogFile}

#-------------------------------------------#
# generate the sql statement to create table 
#-------------------------------------------#

echo "Step 3.1: create table DeferredRev.PositiveChart${RepMon}${RepYear} " >> ${LogFile}

SQL_FileName=create_table_PositiveChart.sql

echo "IF OBJECT_ID('DeferredRev.PositiveChart${RepMon}${RepYear}') IS NOT NULL" > ${SQL_FileName}
echo "BEGIN" >> ${SQL_FileName}
echo "   DROP TABLE DeferredRev.PositiveChart${RepMon}${RepYear}" >> ${SQL_FileName}
echo "END"   >> ${SQL_FileName}
echo "ELSE BEGIN" >> ${SQL_FileName}
echo "   PRINT 'THERE IS NO TABLE DeferredRev.PositiveChart${RepMon}${RepYear}' " >> ${SQL_FileName}
echo "END"   >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}
echo "CREATE TABLE DeferredRev.PositiveChart${RepMon}${RepYear}" >> ${SQL_FileName}
echo "("     >> ${SQL_FileName}
echo "  userId              numeric(12,0) NOT NULL" >> ${SQL_FileName}
echo ", dateLastPurchased      datetime      NULL" >> ${SQL_FileName}
echo ", initialBalance         int           NULL" >> ${SQL_FileName}
echo ", creditLastPurchased    int           NULL" >> ${SQL_FileName}

LIMIT=181
CreditUsedDay=1

while [ "${CreditUsedDay}" -lt "${LIMIT}" ]
do
  echo ", creditConsumedD${CreditUsedDay} int NULL  " >> ${SQL_FileName} # -n suppresses newline.
  CreditUsedDay=`expr ${CreditUsedDay} + 1` ### CreditUsedDay=$(($CreditUsedDay+1)) also works.
done

echo ")"     >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}

isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}

#-----------------------------------------------
# generate sql for creating DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear} 
#-----------------------------------------------

SQL_FileName=create_table_PositiveChartCreditUsed.sql

echo "IF OBJECT_ID('DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}') IS NOT NULL" > ${SQL_FileName}
echo "BEGIN" >> ${SQL_FileName}
echo "   DROP TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}" >> ${SQL_FileName}
echo "END"   >> ${SQL_FileName}
echo "ELSE BEGIN" >> ${SQL_FileName}
echo "   PRINT 'THERE IS NO TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}' " >> ${SQL_FileName}
echo "END"   >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}
echo "CREATE TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}" >> ${SQL_FileName}
echo "("     >> ${SQL_FileName}
echo "  userId              numeric(12,0) NOT NULL" >> ${SQL_FileName}

LIMIT=181
CreditUsedDay=1

while [ "${CreditUsedDay}" -lt "${LIMIT}" ]
do
  echo ", creditConsumedD${CreditUsedDay} int NULL  " >> ${SQL_FileName} # -n suppresses newline.
  CreditUsedDay=`expr ${CreditUsedDay} + 1` ### CreditUsedDay=$(($CreditUsedDay+1)) also works.
done

echo ")"     >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}

isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}


###  echo "Step 3.2: create table DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear} " >> ${LogFile}

isql -U${UserName} -S${DestServerName} -P${DestPassword} << EOQ32 >> ${LogFile}

PRINT "Step 3.2: create table DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}
(
     userId                 numeric(12,0) NOT NULL
   , dateLastPurchased      datetime      NULL
   , dayLastPurchased       datetime      NULL
)
go

print "Step 3.3 -- populate data into DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear} "  

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

INSERT DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}
(
    userId      ,
    dateLastPurchased,
    dayLastPurchased
)
SELECT
    userId,
    MAX(dateCreated) AS dateLastPurchased,
    convert(varchar(20), MAX(dateCreated), 107) as dayLastPurchased
FROM DeferredRev.AccountTransaction
WHERE xactionTypeId = 6 and creditTypeId = 1 and  dateCreated < @RepDate 
  and dateCreated >= "Nov 12 2002"
GROUP BY userId

select count(*) from DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}
go

PRINT "Step 3.3.1 --delete Banned User "

delete from DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}  
where userId in (select userId from DeferredRev.BannedUser${RepMon}${RepYear} )
go

select count(*) from DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}
go

create unique index ndx_PCLastPurchaseUserId on DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear}(userId)
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

PRINT "Step 3.4-- create table DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily  "
IF OBJECT_ID('DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily "
END
go

CREATE TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily
(
     userId                 numeric(12,0) NOT NULL
   , dateCreated            datetime      NULL
   , creditsSumDaily        int           NULL
)
go

PRINT "Step 3.4.1 -- populate data into table DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily  "

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

INSERT DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily
(
     userId            
   , dateCreated      
   , creditsSumDaily    
)
SELECT 
     userId
   , convert(datetime, convert(varchar(20), dateCreated, 107) ) 
   , SUM(credits) 
FROM DeferredRev.AccountTransaction
WHERE creditTypeId = 1 -- regular credit
  and xactionTypeId in (1,2,3,4,21,22,23,24,25,26,28) --consumption
  and dateCreated < @RepDate
  and dateCreated >= "Nov 12 2002" 
GROUP BY userId, convert(datetime, convert(varchar(20), dateCreated, 107) ) 
go

SELECT COUNT(*) FROM DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily
go

PRINT "Step 3.5: create table DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear} "

IF OBJECT_ID('DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}"
END
go

CREATE TABLE DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}
(
     userId                 numeric(12,0) NOT NULL
   , dateLastPurchased      datetime      NULL
   , initialBalance         int           NULL
   , creditLastPurchased    int           NULL
)
go

print "Step 3.6 -- populate data into DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear} "

DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))

INSERT DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}
(
     userId      
   , dateLastPurchased
   , initialBalance  
   , creditLastPurchased    
)
SELECT
     a.userId
   , a.dateCreated as dateLastPurchased
   , a.balance     as initialBalance
   , a.credits     as creditLastPurchased 
FROM DeferredRev.AccountTransaction a, DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear} b 
WHERE a.userId = b.userId and a.dateCreated = b.dateLastPurchased 
go

select count(*) from DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}
go

EOQ32

#----------------------------------------------------------------------------------------#
#  Step 3.7 -- populate data into DeferredRev.PositiveChart${RepMon}${RepYear}           # 
#              from DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear}            #
#----------------------------------------------------------------------------------------#

SQL_FileName=insert_table_PositiveChart.sql

echo "DECLARE @RepDate  datetime" > ${SQL_FileName}
echo "SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))" >> ${SQL_FileName}
echo "" >> ${SQL_FileName}

echo "INSERT DeferredRev.PositiveChart${RepMon}${RepYear}" >> ${SQL_FileName}
echo "("     >> ${SQL_FileName}
echo "  userId              " >> ${SQL_FileName}
echo ", dateLastPurchased   " >> ${SQL_FileName}
echo ", initialBalance      " >> ${SQL_FileName}
echo ", creditLastPurchased " >> ${SQL_FileName}

LIMIT=181
CreditUsedDay=1

while [ "${CreditUsedDay}" -lt "${LIMIT}" ]
do
  echo ", creditConsumedD${CreditUsedDay}  " >> ${SQL_FileName} # -n suppresses newline.
  CreditUsedDay=`expr ${CreditUsedDay} + 1` ### CreditUsedDay=$(($CreditUsedDay+1)) also works.
done

echo ")"     >> ${SQL_FileName}

echo "SELECT"     >> ${SQL_FileName}
echo "  a.userId              " >> ${SQL_FileName}
echo ", a.dateLastPurchased   " >> ${SQL_FileName}
echo ", a.initialBalance      " >> ${SQL_FileName}
echo ", a.creditLastPurchased " >> ${SQL_FileName}

LIMIT=181
CreditUsedDay=1

while [ "${CreditUsedDay}" -lt "${LIMIT}" ]
do
  echo ", 0  " >> ${SQL_FileName} # -n suppresses newline.
  CreditUsedDay=`expr ${CreditUsedDay} + 1` ### CreditUsedDay=$(($CreditUsedDay+1)) also works.
done

echo "FROM DeferredRev.PositiveChartLastBuyCredit${RepMon}${RepYear} a " >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}
echo "select count(*) from DeferredRev.PositiveChart${RepMon}${RepYear}" >> ${SQL_FileName}
echo "go"    >> ${SQL_FileName}

echo "Step 3.7 --populate data into DeferredRev.PositiveChart${RepMon}${RepYear} without creditConsumed daily " >> ${LogFile}

isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}

#-----------------------------------------------#
# generate the sql for insert DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear} for 180 times
#-----------------------------------------------#

LIMIT=181
CreditUsedDay=1

while [ "${CreditUsedDay}" -lt "${LIMIT}" ]
do

   SQL_FileName=insert_table_PositiveChartCreditUsedD${CreditUsedDay}.sql

   echo "IF OBJECT_ID('DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}') IS NOT NULL" > ${SQL_FileName}
   echo "BEGIN" >> ${SQL_FileName}
   echo "   DROP TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}" >> ${SQL_FileName}
   echo "END"   >> ${SQL_FileName}
   echo "ELSE BEGIN" >> ${SQL_FileName}
   echo "   PRINT 'THERE IS NO TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}' " >> ${SQL_FileName}
   echo "END"   >> ${SQL_FileName}
   echo "go"    >> ${SQL_FileName}
   echo "CREATE TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}" >> ${SQL_FileName}
   echo "("     >> ${SQL_FileName}
   echo "  userId                          numeric(12,0) NOT NULL" >> ${SQL_FileName}
   echo ", creditConsumedD${CreditUsedDay} int           NULL"     >> ${SQL_FileName}
   echo ")"     >> ${SQL_FileName}
   echo "go"     >> ${SQL_FileName}


   echo "DECLARE @RepDate  datetime" >> ${SQL_FileName}
   echo "SELECT  @RepDate = convert(datetime, convert(varchar(10), ${ReportDate}))" >> ${SQL_FileName}
   echo "" >> ${SQL_FileName}



   echo "INSERT DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}" >> ${SQL_FileName}
   echo "("     >> ${SQL_FileName}
   echo "  userId              " >> ${SQL_FileName}
   echo ", creditConsumedD${CreditUsedDay}  " >> ${SQL_FileName} # -n suppresses newline.
   echo ")"     >> ${SQL_FileName}
   echo "SELECT"     >> ${SQL_FileName}
   echo "  a.userId              " >> ${SQL_FileName}

   CreditUsedDay1=`expr ${CreditUsedDay} - 1`
   echo ", a.creditsSumDaily  AS creditConsumedD${CreditUsedDay}" >>${SQL_FileName}
   echo "FROM   DeferredRev.PositiveChartLastPurchase${RepMon}${RepYear} c, " >>${SQL_FileName} 
   echo "       DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}SumDaily  a " >> ${SQL_FileName}
   echo "WHERE  a.userId  = c.userId " >> ${SQL_FileName}
   echo "  and  a.dateCreated = dateadd(dd,${CreditUsedDay1}, c.dayLastPurchased) " >> ${SQL_FileName}
   echo "go"    >> ${SQL_FileName}
   echo "select count(*) from DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}" >> ${SQL_FileName}
   echo "go"    >> ${SQL_FileName} 

   echo "UPDATE DeferredRev.PositiveChart${RepMon}${RepYear} " >> ${SQL_FileName}
   echo "SET    a.creditConsumedD${CreditUsedDay} = b.creditConsumedD${CreditUsedDay} " >> ${SQL_FileName}  
   echo "FROM   DeferredRev.PositiveChart${RepMon}${RepYear} a, " >> ${SQL_FileName} 
   echo "       DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay}  b " >> ${SQL_FileName}
   echo "WHERE  a.userId = b.userId " >> ${SQL_FileName} 
   echo "go"    >> ${SQL_FileName}
   echo "select count(*) from DeferredRev.PositiveChart${RepMon}${RepYear}" >> ${SQL_FileName}
   echo "go"    >> ${SQL_FileName}

   echo "DROP TABLE DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay} " >> ${SQL_FileName}
   echo "go"    >> ${SQL_FileName}
 
   echo "Step 3.8 --populate data into DeferredRev.PositiveChartCreditUsed${RepMon}${RepYear}D${CreditUsedDay} " >> ${LogFile}
   date >> ${LogFile} 
   isql -U${UserName} -S${DestServerName} -P${DestPassword} -i ${SQL_FileName} >> ${LogFile}

   CreditUsedDay=`expr ${CreditUsedDay} + 1`       ### CreditUsedDay=$(($CreditUsedDay+1)) also works.
   rm ${SQL_FileName}

done


cat ${LogFile}

exit 0


