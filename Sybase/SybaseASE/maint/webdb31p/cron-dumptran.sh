#!/bin/bash

if [ $# -ne 3 ] ; then
  echo "Usage: <Database Name> <ASE Identifier> <Hot Backup> "
  exit 1
fi

#
# Initialize arguments
#

DatabaseName=$1
ASEIdentifier=$2
HotBackup=$3

JobId=`cat DumpTranSchedule.ini | grep ${DatabaseName} | awk '{print $2}'`
ScheduleId=`cat DumpTranSchedule.ini | grep ${DatabaseName} | awk '{print $3}'`

Hour=`date +"%H"`
Min=`date +"%M"`
if [ $Hour -lt 5 ]; then
 Hour=`expr $Hour + 24 `
 fi
TimeStamp=${Hour}${Min}

. /opt/etc/sybase/.bash_profile

ServerName=$DSQUERY
Password=`cat $HOME/.sybpwd | grep ${ServerName} | awk '{print $2}'`
BackupServerStatus=$SYBMAINT/logs/$DatabaseName/BackupServerStatus.tran
MSG_LOG=$SYBMAINT/logs/$DatabaseName/cron-dumptran.${DatabaseName}.mail
LogFile=$SYBMAINT/logs/$DatabaseName/$0.log
LogAll=$SYBMAINT/logs/$DatabaseName/cron-dumptran.${DatabaseName}.all.out

#--------------------------------------------#
#   Function ErrorHandler                    #
#--------------------------------------------#
function ErrorHandler
{
echo "######################"
echo " EXECUTING FUNCTION   "
echo "${JobId},${ScheduleId},${executionNote},${executionStatus},${jobSpecificCode},${logLocation}"
echo "######################"

ssh backmon@opsdb1p "/home/backmon/executionInsert.sh ${JobId} ${ScheduleId} '${executionNote}' ${executionStatus} ${jobSpecificCode} ${LogFile}"
}

rm $SYBDUMP/${DatabaseName}/${DatabaseName}-tran$TimeStamp-1

date > ${BackupServerStatus}

isql -S${ServerName} -Usa -P${Password} <<EOF2 >> ${BackupServerStatus} 
SYB_BACKUP...sp_who
go
EOF2

date >> ${BackupServerStatus}

egrep -e "Msg 42|error" ${BackupServerStatus}  > ${BackupServerStatus}.err 

if [ -s "${BackupServerStatus}.err" ]
then
    mailx -s "Could not connect to Backup server when dump "${DSQUERY}.${DatabaseName} ${SYBMAILTO} < ${BackupServerStatus}.err 
    sleep 60
fi

isql -S${ServerName} -Usa -P${Password} -o ${LogFile} <<EOF1 
PRINT "========================"
SELECT GETDATE()

DUMP TRANSACTION ${DatabaseName} to "$SYBDUMP/${DatabaseName}/${DatabaseName}-tran$TimeStamp-1"
go

SELECT GETDATE()
PRINT "========================"
go

EOF1

egrep -e "Msg 42|error" ${LogFile}  > ${LogFile}.tmp

if [ -s "${LogFile}.tmp" ]     ## error log is not empty, it means something wrong
then
   printf "Incremental Backup Failed at ${ServerName}.${DatabaseName},\nPlease Check.\n"> ${MSG_LOG}
   egrep -e "Msg 42|error" ${LogFile} >> ${MSG_LOG}
   mailx -s "Incremental Backup Failed at "${ServerName}.${DatabaseName} ${SYBMAILTO} < ${MSG_LOG}
   executionStatus="2"
   jobSpecificCode="1" 
   executionNote=$0" failed at "${ServerName}.${DatabaseName}";Please call DBM; LogFile: "${LogFile}    
   ErrorHandler    ## invoke teh function  
else
   executionStatus="1"
   jobSpecificCode="1"
   executionNote=$0" has been done successfully at "${ServerName}.${DatabaseName}
   ErrorHandler    ## invoke teh function 
fi

cat ${LogFile} >> ${LogAll} 

# Copy the transaction dump to ${HotBackup}

# echo "Copying transaction dump to ${HotBackup}"
# rcp  $SYBDUMP/${DatabaseName}/${DatabaseName}-tran$TimeStamp-1 ${HotBackup}:$SYBDUMP/webdb${ASEIdentifier}p/${DatabaseName}

#scp -pB $SYBDUMP/${DatabaseName}/${DatabaseName}-tran$TimeStamp-1 ${HotBackup}:${SYBDUMP}/webdb${ASEIdentifier}p/${DatabaseName} &
#scp -pB $SYBDUMP/${DatabaseName}/${DatabaseName}-tran$TimeStamp-1 vgstor2:/data2/sybase/webdb${ASEIdentifier}p/${DatabaseName}

exit 0
