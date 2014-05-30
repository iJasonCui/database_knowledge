#!/bin/bash

. $HOME/.bash_profile

cd $SYBMAINT/MDA

if [ $# -ne 1 ]
then 
   echo "Usage: ${0} <SOURCE_SRV_NAME> ; for example, ${0} v151dbp01ivr"
   exit -1
else
   SOURCE_SRV=${1}
   SOURCE_PASSWD=`cat $HOME/.sybpwd | grep -w ${SOURCE_SRV} | awk '{print $2}'` 
   SOURCE_USER=mda_user

fi

DEST_SRV=g104iqdb01
DEST_USER=cron_sa
DEST_PASS=`cat $HOME/.sybpwd | grep -w ${DEST_SRV} | awk '{print $2}'`
SQL_FILE=$SYBMAINT/MDA/${0}.sql.${SOURCE_SRV}

WhatDay=`date | grep E | cut -c1-3 `
LogDir=$SYBMAINT/MDA/logs/
LogFile=${LogDir}/${0}.${SOURCE_SRV}.${WhatDay}
BCP_PATH=/data/dump/g104iqdb01/bcp-data/MDA

rm ${LogFile}
 
cd $SYBMAINT/MDA

#----------------------------------------------#
# step 1: bcp out from source server 
#----------------------------------------------#

if [ -f ${BCP_PATH}/proc_stats.${SOURCE_SRV} ]
then
      rm ${BCP_PATH}/proc_stats.${SOURCE_SRV}
fi

bcp mda_db..proc_stats out ${BCP_PATH}/proc_stats.${SOURCE_SRV} -c -t "|" -U${SOURCE_USER} -P${SOURCE_PASSWD} -S${SOURCE_SRV}

#-------------------------------------------------------------#
# step 2: TRUNCATE TABLE mda_db..proc_stats from source server
#-------------------------------------------------------------#
 
isql -U${SOURCE_USER} -P${SOURCE_PASSWD} -S${SOURCE_SRV}  > ${LogFile} <<EOF2
select getdate()
TRUNCATE TABLE mda_db..proc_stats
go

EOF2

#-------------------------------------------------------------#
# step 3: load TABLE mda_user.proc_stats 
#-------------------------------------------------------------#

echo "SET TEMPORARY OPTION DATE_ORDER = 'MDY'; " > ${SQL_FILE}
echo "SET TEMPORARY OPTION Date_Format='YYYYMMDD'; " >> ${SQL_FILE}
echo "SET TEMPORARY OPTION Output_Format='TEXT'; " >> ${SQL_FILE}
echo "LOAD TABLE mda_user.proc_stats " >> ${SQL_FILE}
echo "(   " >> ${SQL_FILE}
echo "        SRVName      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,ProcName      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,DBName      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,SPID      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,DBID      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,ProcedureID      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,BatchID      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,CpuTime      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,WaitTime      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,PhysicalReads      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,LogicalReads      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,PacketsSent      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,StartTime      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,EndTime      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,ElapsedTime      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,dateCreated      '|'  NULL('NULL') " >> ${SQL_FILE}
echo "        ,NumExecs     '\n'  ) " >> ${SQL_FILE}
echo "FROM '${BCP_PATH}/proc_stats.${SOURCE_SRV}'" >> ${SQL_FILE}
echo "FORMAT ascii " >> ${SQL_FILE}
echo "STRIP OFF " >> ${SQL_FILE}
echo "QUOTES OFF " >> ${SQL_FILE}
echo "ESCAPES OFF " >> ${SQL_FILE}
echo "PREVIEW ON " >> ${SQL_FILE}
echo "NOTIFY 100000 " >> ${SQL_FILE}
echo "; " >> ${SQL_FILE}
echo "COMMIT; " >> ${SQL_FILE}
 

##dbisqlc -c "uid=${DEST_USER};pwd=${DEST_PASS};eng=${DEST_SRV}" -q ${SQL_FILE}
dbisqlc -q ${SQL_FILE}  

exit 0


