#!/bin/sh

if [ $# -ne 4 ] ; then
  echo "Usage: <Database Name> <Database Identifier> <jobId> <scheduleId>"
  exit 1
fi

#
# Initialize arguments
#

DatabaseName=$1
DatabaseIdentifier=$2

jobId=$3
scheduleId=$4

SYBDUMP=/dumps

. /home/sybase/.bash_profile
Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -S${DSQUERY} -Ucron_sa -P${Password} <<EOF1

DUMP DATABASE ${DatabaseName} TO "$SYBDUMP/${DatabaseName}/${DatabaseName}-db${DatabaseIdentifier}"
go
EOF1


function ErrorHandler
{

echo "######################"
echo " EXECUTING FUNCTION   "
echo "${jobId},${scheduleId},${executionNote},${executionStatus},${jobSpecificCode},${logLocation}"
echo "######################"

$SYBMAINT/executionInsert.sh ${jobId} ${scheduleId} "${executionNote}" ${executionStatus} ${jobSpecificCode} ${logLocation}

}


MsgCount=`grep Msg ./cron-dumpdb-${DatabaseName}.out | wc -l | awk '{print $1}'`
ErrorCount=`grep error ./cron-dumpdb-${DatabaseName}.out | wc -l | awk '{print $1}'`

MsgLog=`cat ./cron-dumpdb-${DatabaseName}.out |grep Msg | awk '{ print $1,$2}' |sort | uniq`
ErrorLog=`cat ./cron-dumpdb-${DatabaseName}.out |grep error | awk '{ print "\n", $3,$4,$5}'| sort | uniq`

#echo MsgCount= ${MsgCount}
#echo ErrorCount= ${ErrorCount}

# Returns true if either condition1 or condition2 holds true...
if [[(${MsgCount} > 0) || ( ${ErrorCount} > 0)]]


then

        jobId=${jobId}
        scheduleId=${scheduleId}
        executionNote="opsdb1p.${DatabaseName} daily dump failed. CALL DBM ${MsgLog} ${ErrorLog}"
        executionStatus="2"
        jobSpecificCode="1"
        logLocation="/dumps/scripts/maint/cromdumpdb-${DatabaseName}.out"


        ErrorHandler $jobId,$scheduleId},${executionId},"${executionNote}",${executionStatus},${jobSpecificCode},${logLocation}

else



        jobId=${jobId}
        scheduleId=${scheduleId}
        executionNote="opsdb1p.${DatabaseName} daily dump FINISHED OK"
        executionStatus="1"
        jobSpecificCode="1"
        logLocation="/dumps/scripts/maint/cromdumpdb-${DatabaseName}.out"

        ErrorHandler $jobId,${scheduleId},${executionId},"${executionNote}",${executionStatus},${jobSpecificCode},${logLocation}


fi


exit 0
