#!/bin/bash

set -x

. $HOME/.bash_profile

#----------------------------------------------------
# Check Parameters
#----------------------------------------------------
#if [ $# -ne 3 ] ; then
#  echo "Usage: <DB_SERVER> <JOB_ID> <SCHEDULE_ID>"
#  exit 1
#fi

DB_SERVER=g104iqdb01
JOB_ID=${2}
SCHEDULE_ID=${3}
SRVHOST=`hostname`

#----------------------------------------------------
# Source Environment and get password
#----------------------------------------------------
Password=`cat $HOME/.sybpwd | grep -w ${DB_SERVER} | awk '{print $2}'`

#now=`date +%Y%m%d`

purge_proc_stats()
{
isql -S ${DB_SERVER} -Ucron_sa -P${Password} << EOF > /tmp/sql01.$$ 2>&1
EXEC mda_user.p_purge_proc_stats
go
exit
EOF

}

#------------------------
# MAINLINE
#------------------------

#------------------------------
# house keeping
#------------------------------
find . -name "purge_mda_proc_stats.sh.log.*" -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null


isql -S ${DB_SERVER} -Ucron_sa -P${Password} << EOF 
EXEC mda_user.p_purge_proc_stats
go
EOF


RC=$?

if [ $RC -ne 0 ]; then
     echo "Backup of ${DB_SERVER} failed"
     cat /tmp/err01.$$

     EXECUTION_NOTE="$0 failed for ${DB_SERVER} on ${SRVHOST} - Please call DMB"
     EXECUTION_STATUS="2"
     JOB_SPECIFIC_CODE="1"
     LOGFILE=$0.out

else
     echo "Backup of ${DB_SERVER} successfull"

     EXECUTION_NOTE="$0 has been done successfully for ${DB_SERVER} on ${SRVHOST} "
     EXECUTION_STATUS="1"
     JOB_SPECIFIC_CODE="1"
     LOGFILE=$0.out
fi 
