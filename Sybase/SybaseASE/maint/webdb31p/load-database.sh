#!/bin/bash

#***************************************#
# load-database.sh
# Author: Jason C.
# Date: Oct 18 2004
# Function: Load database
# 
#***************************************#

if [ $# -ne 2 ] ; then
  echo "Usage: <Database Name> <Database Identifier> "
  exit 1
fi

#--------------------------------#
# Initialize arguments
#--------------------------------#

DatabaseName=$1
DatabaseIdentifier=$2

JobId=`cat DumpDatabaseSchedule.ini | grep -w ${DatabaseName} | awk '{print $2}'`
ScheduleId=`cat DumpDatabaseSchedule.ini | grep -w ${DatabaseName} | awk '{print $3}'`
StripesCount=`cat DumpDatabaseSchedule.ini | grep -w ${DatabaseName} | awk '{print $4}'`

. /opt/etc/sybase/.bash_profile

ServerName=$DSQUERY
LogFile=$SYBMAINT/logs/$DatabaseName/$0.log
BackupServerStatus=$SYBMAINT/logs/$DatabaseName/BackupServerStatus
Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`
SQLLoaddb=$SYBMAINT/Load_db_$DatabaseName.sql
MSG_LOG=$SYBMAINT/logs/$DatabaseName/load-database.${DatabaseName}.mail


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

#--------------------------------------------#
#   Function GenerateSQL()                   #
#--------------------------------------------#
GenerateSQL() 
{
  echo "PRINT \"========================\" " >  ${SQLLoaddb}
  echo "SELECT GETDATE()"                    >> ${SQLLoaddb}
  echo ""                                    >> ${SQLLoaddb}
  echo "LOAD DATABASE "${DatabaseName}" FROM '"$SYBDUMP"/"${DatabaseName}"/"${DatabaseName}"-db"${DatabaseIdentifier}"-1'" >> ${SQLLoaddb}

  StripeIndex=1
  while [ "${StripeIndex}" -ne "${StripesCount}" ]  
  do
    let "StripeIndex+=1"   
    echo "STRIPE ON '"$SYBDUMP"/"${DatabaseName}"/"${DatabaseName}"-db"${DatabaseIdentifier}"-"${StripeIndex}"'" >> ${SQLLoaddb}
  done
	
  echo "go"                                  >> ${SQLLoaddb}
  echo ""                                    >> ${SQLLoaddb}
  echo "SELECT GETDATE()"                    >> ${SQLLoaddb}
  echo "PRINT \"========================\" " >> ${SQLLoaddb}
  echo "go"                                  >> ${SQLLoaddb}
 
}

echo "Load Database "${DatabaseName} > ${LogFile}

date > ${BackupServerStatus}

/opt/sybase12_52/OCS-12_5/bin/isql -S${ServerName} -Usa -P${Password} <<EOF2 >> ${BackupServerStatus} 
SYB_BACKUP...sp_who
go
EOF2

date >> ${BackupServerStatus}

egrep -e "Msg 42|error" ${BackupServerStatus}  > ${BackupServerStatus}.err 

if [ -s "${BackupServerStatus}.err" ]
then
    mailx -s "Could not connect to Backup server when Load "${DSQUERY}.${DatabaseName} ${SYBMAILTO} < ${BackupServerStatus}.err 
    sleep 60
fi

#-----------------------------------------------#
# generate the sql statement to Load database
#-----------------------------------------------#
GenerateSQL 

/opt/sybase12_52/OCS-12_5/bin/isql -S${ServerName} -Usa -P${Password} -i ${SQLLoaddb} >> ${LogFile}

egrep -e "Msg 42|error" ${LogFile}  > ${LogFile}.tmp

if [ -s "${LogFile}.tmp" ]     ## error log is not empty, it means something wrong
then
   printf "Full Backup Failed at ${ServerName}.${DatabaseName},\nPlease Check.\n"> ${MSG_LOG}
   egrep -e "Msg 42|error" ${LogFile} >> ${MSG_LOG}
   mailx -s "Full Backup Failed at "${ServerName}.${DatabaseName} ${SYBMAILTO} < ${MSG_LOG}
   executionStatus="2"
   jobSpecificCode="1" 
   executionNote=$0" failed at "${ServerName}.${DatabaseName}";Please call DBM; LogFile: "${LogFile}    
#   ErrorHandler    ## invoke teh function  
else
   executionStatus="1"
   jobSpecificCode="1"
   executionNote=$0" has been done successfully at "${ServerName}.${DatabaseName}
#   ErrorHandler    ## invoke teh function 
fi

exit 0 

