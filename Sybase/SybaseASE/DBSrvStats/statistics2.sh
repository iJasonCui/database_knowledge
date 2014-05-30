#!/bin/bash

set -x

. $HOME/.bash_profile

if [ $# != 1 ]
then
   echo "Usage: "${0}" <SERVER_NAME> "
   exit 1
else
   SERVER_NAME=${1}
fi

OPS_DB_SERVER=g151opsdb02
OPS_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_DB_SERVER} | awk '{print $2}'`
PROCESS_TIME=`date +%Y%m%d%H%M%S`
WORK_DIR=${SYBMAINT}/DBSrvStats
LOG_FILE=${SERVER_NAME}.${PROCESS_TIME}
BACKUP_DIR=/data/dump/StagingFiles/DBSrvStats/${SERVER_NAME}/

Password=`cat $HOME/.sybpwd | grep -w ${SERVER_NAME} | awk '{print $2}'`

cd ${WORK_DIR}

isql -S${SERVER_NAME} -Ucron_sa -P${Password}  -i sp_sysmon_noclear.sql -o ${LOG_FILE} 

./process_stats_125 ${LOG_FILE} 

bcp DBSrvStats..parsed_sp_sysmon in ${WORK_DIR}/${SERVER_NAME} -Ucron_sa -P${OPS_PASSWORD} -S${OPS_DB_SERVER} -c -t "|~" -r "|@|" -e ${0}.err 

mv ${WORK_DIR}/${LOG_FILE} ${BACKUP_DIR} 

WhatDay=`date | grep E | cut -c1-3 `

case ${WhatDay} in 
"Sat") 
    /usr/bin/find ${BACKUP_DIR} -name ${SERVER_NAME}".*" -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null 
;;
"Wed")
    /usr/bin/find ${BACKUP_DIR} -name ${SERVER_NAME}".*" -mtime +10 -exec rm -f {} \; 2>&1 > /dev/null
;;
esac

exit 0


