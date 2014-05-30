#!/bin/bash

. $HOME/.bash_profile

OPS_DB_SERVER=g151opsdb02
OPS_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_DB_SERVER} | awk '{print $2}'`
PROCESS_TIME=`date +%Y%m%d%H%M%S`
WORK_DIR=$SYBMAINT/DBSrvStats
LOG_FILE=cpu_util.out

cd ${WORK_DIR}

if [ -f ${LOG_FILE} ]
then
   rm ${LOG_FILE}
fi

isql -S${OPS_DB_SERVER} -Ucron_sa -P${OPS_PASSWORD} -i ${WORK_DIR}/getCPU.sql > ${WORK_DIR}/${LOG_FILE} 

mailx -s "CPU utilization for the previous week" andy.tran@lavalife.com,jason.cui@lavalife.com < ${WORK_DIR}/${LOG_FILE} 

exit 0

