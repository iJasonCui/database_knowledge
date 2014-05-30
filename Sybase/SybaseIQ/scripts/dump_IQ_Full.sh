#!/bin/bash

set -x

. $HOME/.bash_profile

#----------------------------------------------------
# Check Parameters
#----------------------------------------------------
if [ $# -ne 3 ] ; then
  echo "Usage: <DB_SERVER> <JOB_ID> <SCHEDULE_ID>"
  exit 1
fi

DB_SERVER=${1}
JOB_ID=${2}
SCHEDULE_ID=${3}
SRVHOST=`hostname`

#----------------------------------------------------
# Source Environment and get password
#----------------------------------------------------
Password=`cat $HOME/.sybpwd | grep -w ${DB_SERVER} | awk '{print $2}'`

#now=`date +%Y%m%d`

dump_database()
{
isql -S ${DB_SERVER} -Ucron_sa -P${Password} << EOF > /tmp/sql01.$$ 2>&1
BACKUP DATABASE FULL
TO '/data/dump/g104iqdb01/${DB_SERVER}_Full.dmp'
go
exit
EOF

## Check if ISQL was successful
##
if [ $? = 0 ]; then
   egrep "error|ERROR|failed|FAILED|Msg|Server" /tmp/sql01.$$ >/tmp/err01.$$

   if [ -s /tmp/err01.$$ ]; then
      print " "
      print "ERROR:  SQL errors detected in ISQL output from function dump_database"
      return 1
   else
      return 0
   fi
else
   print " "
   print "ERROR:  Unable to ISQL into server ${SERVER_NAME} from function dump_database"
   return 1
fi

}

#------------------------
# MAINLINE
#------------------------

dump_database
RC=$?

if [ $RC -ne 0 ]; then
     echo "Backup of ${DB_SERVER} failed"
     cat /tmp/err01.$$

     EXECUTION_NOTE="$0 failed for ${DB_SERVER} on ${SRVHOST} - Please call DMB"
     EXECUTION_STATUS="2"
     JOB_SPECIFIC_CODE="1"
     LOGFILE=$0.out
     ssh backmon@opsdb1p "/home/backmon/executionInsert.sh ${JOB_ID} ${SCHEDULE_ID} '${EXECUTION_NOTE}' ${EXECUTION_STATUS} ${JOB_SPECIFIC_CODE} ${LOGFILE}"

else
     echo "Backup of ${DB_SERVER} successfull"

     EXECUTION_NOTE="$0 has been done successfully for ${DB_SERVER} on ${SRVHOST} "
     EXECUTION_STATUS="1"
     JOB_SPECIFIC_CODE="1"
     LOGFILE=$0.out
     ssh backmon@opsdb1p "/home/backmon/executionInsert.sh ${JOB_ID} ${SCHEDULE_ID} '${EXECUTION_NOTE}' ${EXECUTION_STATUS} ${JOB_SPECIFIC_CODE} ${LOGFILE}"

     scp -p /data/dump/g104iqdb01/g104iqdb01_Full.dmp* rsyncs@vmaster:/data/data3/rsyncs/reporting/g104iqdb01/

fi 
