#!/bin/bash
#==================================================================================================
# ScriptName  : emailMDAStats.sh
#
# Description : This script gathers statistics from the MDA Repository stored 
#               on IQ and sends email to configured recipients
#
#
# Revision    : YYYY-MM-DD      User        Description
#               ==========      =======     ======================================================
#               2009-01-13      cmessa      New 
#
#==================================================================================================
trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

#--------------------------------------------------------
# Check parameters
#--------------------------------------------------------
if [  $# -lt 1 -o  $# -gt 5 ]; then
   echo  "Usage: emailMDAStats.sh <ASE ServerName> 20100411 20100412 20100404 20100405 "
   exit 1
fi

set -x

#--------------------------------------------------------
# Source Sybase environment
#--------------------------------------------------------
. $HOME/.bash_profile

#--------------------------------------------------------
# Assign Variables
#--------------------------------------------------------
aseServer=$1 
##startDate=${2:-`TZ=$TZ+24 date +%Y%m%d`}              # date of load 
##enDate=${3:-`date +%Y%m%d`}
startDate=${2}
enDate=${3}
startDateCompare=${4}
enDateCompare=${5}

SQLUSR=cron_sa
SERVER_NAME=g104iqdb01
PASSWD=`cat $HOME/.sybpwd | grep -w ${SERVER_NAME} | awk '{print $2}'`
iqcmd="dbisqlc -q "           # IQ dbisql command
MAIL_LIST="${SYBMAINT}/send_mail/mail_list.txt"
MAIL_SCRIPT="${SYBMAINT}/send_mail/send_mail.sh"
MAIL_FILE=$SYBMAINT/MDA/output/$0.${aseServer}.mail
REPORT=$SYBMAINT/MDA/output/mda_report.${aseServer}.${startDate}
MAIL_FLAG=1
ERROR_CODE=0


#------------------------------------------------
# Extract Report Information
#------------------------------------------------
extractReportInfo()
{
isql -U${SQLUSR}  -P${PASSWD} -S${SERVER_NAME} -w300 << EOF > /tmp/sql01.$$ 2>&1
set nocount on

print '========================================================================='
print '               Procedure Execution Statistics'
print 'Monitored_Server: ${aseServer}'
print 'Start Date      : ${startDate}'
print 'End Date        : ${enDate}'
print '========================================================================='
print ''

print '-------------------------------------------------------------------------'
print 'Top 20 Elapsed Time (slow) Stored Procedures               '
print '-------------------------------------------------------------------------'
print '  '
go
select top 20 ProcName, DBName, ElapsedTime, StartTime
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDate}'
  and dateCreated < '${enDate}'
order by ElapsedTime desc

print '-----------------------------------------------------------------------'
print 'Top 20 Logical Read (expensive) Stored Procedures               '
print '-----------------------------------------------------------------------'
print '  '
go
select top 20 ProcName, DBName, LogicalReads, StartTime
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDate}'
  and dateCreated < '${enDate}'
order by LogicalReads desc

print '-----------------------------------------------------------------------'
print 'Top 20 Been Executed (popular) Stored Procedures               '
print '-----------------------------------------------------------------------'
print '  '
go
select DBName, ProcName, count(*) as ExecCount, 
       min(ElapsedTime) as minExeTime, max(ElapsedTime) as maxExeTime, convert(int, avg(ElapsedTime)) as avgExeTime   
into #MostExecuted
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDate}'
  and dateCreated < '${enDate}'
group by DBName, ProcName 

select top 20 t.ProcName,
       convert(varchar(15),t.DBName) as DBName,
       ExecCount ,
       minExeTime, 
       maxExeTime,
       avgExeTime
from #MostExecuted t
order by ExecCount desc

print '-----------------------------------------------------------------------'
print 'Stored Procedures were executed in the previous day, not in reporting period '
print '-----------------------------------------------------------------------'
print '  '

select DBName, ProcName, count(*) as ExecCount, min(dateCreated) as min_startTime, max(dateCreated) as max_startMax
into #MostExecutedPrevious
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDateCompare}'
  and dateCreated <  '${enDateCompare}'
group by DBName, ProcName

select t1.ProcName, t1.DBName, t1.ExecCount as ExecCount1, t2.ExecCount as ExecCount2  
into   #ProcInYesterdayNotToday
from #MostExecutedPrevious t1, #MostExecuted t2
where t1.ProcName *= t2.ProcName 
  and t1.DBName *= t2.DBName  

select ProcName, DBName, ExecCount1 
from  #ProcInYesterdayNotToday
where ExecCount2 is null

print '------------------------------------------------------------------------------'
print 'Stored Procedures were not executed in the previous day, but in reporting period '
print '------------------------------------------------------------------------------'
print '  '

select t1.ProcName, t1.DBName, t1.ExecCount as ExecCount1, t2.ExecCount as ExecCount2                       
into   #ProcInTodayNotInYesterday
from #MostExecuted  t1, #MostExecutedPrevious t2
where t1.ProcName *= t2.ProcName
  and t1.DBName *= t2.DBName

select ProcName, DBName, ExecCount1                      
from  #ProcInTodayNotInYesterday 
where ExecCount2 is null

print '------------------------------------------------------------------------------'
print 'Stored Procedures were executed 20 percent more or less between the previous day and the reporting period '
print '------------------------------------------------------------------------------'
print '  '

select t1.ProcName, t1.DBName, 
       t1.ExecCount as ExecCount1, 
       t2.ExecCount as ExecCount2, 
       t1.ExecCount - t2.ExecCount as CountDiff, 
       (abs(CountDiff) * 100 / t1.ExecCount) as CountDiffPercent
  into #ProcInTodayInYesterday
  from #MostExecuted  t1, #MostExecutedPrevious t2
 where t1.ProcName = t2.ProcName
   and t1.DBName = t2.DBName

select ProcName, DBName, ExecCount1 , ExecCount2 as ExecCountPrevious, CountDiff, CountDiffPercent
from #ProcInTodayInYesterday
where CountDiffPercent >= 20  
order by CountDiffPercent desc

select top 20 ProcName, DBName, ExecCount1 , ExecCount2 as ExecCountPrevious, CountDiff, CountDiffPercent
from #ProcInTodayInYesterday
order by CountDiffPercent desc

print '-----------------------------------------------------------------------'
print 'Total Stored Proc Executions which ElapsedTime >= 200ms               '
print '-----------------------------------------------------------------------'
print '  '
go

select count(*) as "TotalProcExecElapsedTime>=200ms" 
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDate}'
  and dateCreated < '${enDate}'
  and ElapsedTime >= 200
go

print '-----------------------------------------------------------------------'
print 'Total Stored Proc Executions which ElapsedTime < 200ms                 '
print '-----------------------------------------------------------------------'
print '  '
go

select count(*)  as "TotalProcExecElapsedTime<200ms" 
from mda_user.proc_stats
where SRVName      = '${aseServer}'
  and dateCreated >= '${startDate}'
  and dateCreated < '${enDate}'
  and ElapsedTime < 200
go

print '--------------------------------------------------------------------------------------------------'
go


exit
EOF

RC=$?
## Check if ISQL was successful
##
if [ $RC = 0 ]; then
   egrep -v "Monitored_Server" /tmp/sql01.$$ | egrep "error|ERROR|failed|FAILED|Server" >/tmp/err01.$$

   if [ -s /tmp/err01.$$ ]; then
      echo  " "
      echo  "ERROR:  SQL errors detected in ISQL output from function extractReportInfo"
      return 1
   else
      cat /tmp/sql01.$$ | sed '/affected/d'  >/tmp/mda_report.$$
      return 0
   fi
else
   echo  " "
   echo  "ERROR:  Unable to ISQL into server ${SERVER_NAME} from function extractReportInfo"
   return 1
fi
}


#--------------------------
# MAINLINE 
#--------------------------
echo "---------------------------------------------------------------" > ${MAIL_FILE}
echo "# Run Function to Extract Report                               " >> ${MAIL_FILE}      
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
extractReportInfo
RC=$?
if [ $RC != 0 ]; then
    echo "Error Extracting Report from IQ                            " >> ${MAIL_FILE}
    ERROR_CODE=$RC
    cat /tmp/sql01.$$                                                  >> ${MAIL_FILE}
    cat /tmp/sql01.$$  
else
    echo "Report Extraction was successfull                          " >> ${MAIL_FILE}
    cat /tmp/mda_report.$$ > ${REPORT}
    cat /tmp/mda_report.$$
fi

echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo "# Step 2 - Write Email Message                                 " >> ${MAIL_FILE}
echo "---------------------------------------------------------------" >> ${MAIL_FILE}
echo ''                                                                >> ${MAIL_FILE}   

#echo "=========================================================="     >> ${MAIL_FILE}
if [ ${ERROR_CODE} -eq 0 ]; then
    echo "$0 succeeded at `date`."                                     >> ${MAIL_FILE}
else
    echo "$0 failed at `date`."                                        >> ${MAIL_FILE}
fi

# compose the message type
if [ ${ERROR_CODE} -eq 0 ]; then
   MESSAGE_TYPE='success'
        
   if [  ${MAIL_FLAG} -eq 1 ]
   then
      # ... invoke the mail script
      ${MAIL_SCRIPT} ${REPORT} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
      MAIL_ERROR=$?
   fi
else
   MESSAGE_TYPE='failure'
        
   if [ ${MAIL_FLAG} -eq 1 ]
   then
      # ... invoke the mail script
      ${MAIL_SCRIPT} ${MAIL_FILE} $0 ${MESSAGE_TYPE} ${MAIL_LIST}
      MAIL_ERROR=$?
   fi
fi

exit 0
