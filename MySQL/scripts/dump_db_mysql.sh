#!/bin/bash
# Simple script to backup MySQL databases

. $HOME/.bash_profile

# Treat unset variables as an error when substituting.
##set -u
##set -x

if [ $# -ne 1 ] ; then
  echo "Usage: ${0} <SRV_NAME> "
  exit 1
fi

SRV_NAME=${1}

SRV_IP=`cat $HOME/.mypwd | grep -w ${SRV_NAME} | awk '{print $2}'`
SRV_PORT=`cat $HOME/.mypwd | grep -w ${SRV_NAME} | awk '{print $3}'`
PASS=`cat $HOME/.mypwd | grep -w ${SRV_NAME} | awk '{print $4}'`

USER="root"

# Parent backup directory
DUMP_DIR="/data/dump/"${SRV_NAME}

# Check MySQL password
echo exit | mysql -h${SRV_IP} -P${SRV_PORT}  --user=${USER} --password=${PASS} -B 2>/dev/null
if [ "$?" -gt 0 ]; then
  echo "MySQL ${USER} password incorrect"
  exit 1
else
  echo "MySQL ${USER} password correct."
fi

# Get MySQL databases
MYSQL_DB_LIST=`echo 'show databases' | mysql -h${SRV_IP} -P${SRV_PORT} --user=${USER} --password=${PASS} -B | sed /^Database$/d`

# Backup and compress each database
for DB in $MYSQL_DB_LIST
do

   ## make dir for database dump

   if [ -e ${DUMP_DIR}/${DB} ] 
   then
       echo "the directory exists"
   else 
       mkdir -p ${DUMP_DIR}/${DB} 
       chmod 700 ${DUMP_DIR}/${DB}
   fi

   # keep seven generatio of database dump 
   DUMP_DAY=`date +%w`    

   # database dump file name
   DUMP_FILE=${DUMP_DIR}/${DB}/${DB}.dump.${DUMP_DAY}

   if [ "${DB}" == "information_schema" ] || [ "${DB}" == "performance_schema" ]; then
        DUMP_PARAMS="--skip-lock-tables"
   else
        DUMP_PARAMS=""
   fi

   echo "Creating backup of \"${DB}\" database"

   if [ -e ${DUMP_FILE}.gz ]
   then
      rm ${DUMP_FILE}.gz  
   fi

##   mysqldump ${DUMP_PARAMS} -h${SRV_IP} -P${SRV_PORT} --user=${USER} --password=${PASS} ${DB} | gzip > "${DUMP_FILE}.gz"
##   chmod 600 "${DUMP_FILE}.gz"

   mysqldump ${DUMP_PARAMS} -h${SRV_IP} -P${SRV_PORT} --routines --user=${USER} --password=${PASS} ${DB} > ${DUMP_FILE}

done

exit 0



