##bcpout_load_mda_user_proc_stats_server.sh

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

#-----------------------------------------------------------------------#
# step 3: create TABLE mda_user.proc_stats_[server_name] if not exists  
#-----------------------------------------------------------------------#
SQL_FILE=$SYBMAINT/MDA/${0}.sql.step3.${SOURCE_SRV}

echo "IF NOT EXISTS (SELECT 1 FROM sysobjects o WHERE o.type= 'U' AND o.name = 'proc_stats_${SOURCE_SRV}')" > ${SQL_FILE}
echo "BEGIN " >> ${SQL_FILE}
echo "CREATE TABLE  mda_user.proc_stats_${SOURCE_SRV}  (  "   >> ${SQL_FILE}
echo "   SRVName  varchar(30) NOT NULL,   "     >> ${SQL_FILE}
echo "   ProcName  varchar(30) NOT NULL,   "    >> ${SQL_FILE}
echo "   DBName  varchar(30) NOT NULL,   "      >> ${SQL_FILE}
echo "   SPID  smallint NOT NULL,   "           >> ${SQL_FILE}
echo "   DBID  integer NOT NULL,   "            >> ${SQL_FILE}
echo "   ProcedureID  integer NOT NULL,   "     >> ${SQL_FILE}
echo "   BatchID  integer NOT NULL,   "         >> ${SQL_FILE}
echo "   CpuTime  numeric(15,0) NOT NULL,   "   >> ${SQL_FILE}
echo "   WaitTime  numeric(15,0) NOT NULL,   "  >> ${SQL_FILE}
echo "   PhysicalReads  numeric(15,0) NOT NULL,   "   >> ${SQL_FILE}
echo "   LogicalReads  numeric(15,0) NOT NULL,   "    >> ${SQL_FILE}
echo "   PacketsSent  numeric(15,0) NOT NULL,   "     >> ${SQL_FILE}
echo "   StartTime   datetime  NOT NULL,   "          >> ${SQL_FILE}
echo "   EndTime   datetime  NOT NULL,   "            >> ${SQL_FILE}
echo "   ElapsedTime  numeric(15,0) NOT NULL,   "     >> ${SQL_FILE}
echo "   dateCreated   datetime  NULL, "              >> ${SQL_FILE}
echo "   NumExecs  integer NULL "                     >> ${SQL_FILE}
echo ")  "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  CpuTime_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  CpuTime  ) "   >> ${SQL_FILE}
echo "CREATE DTTM INDEX  dateCreated_DTTM_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  dateCreated  )  "   >> ${SQL_FILE}
echo "CREATE LF INDEX  DBID_LF_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  DBID  )  "   >> ${SQL_FILE}
echo "CREATE LF INDEX  DBName_LF_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  DBName  )  "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  ElapsedTime_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  ElapsedTime  )  "   >> ${SQL_FILE}
echo "CREATE DTTM INDEX  EndTime_DTTM_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  EndTime  )  "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  LogicalReads_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  LogicalReads  )   "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  NumExecs_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  NumExecs  )   "   >> ${SQL_FILE}
echo "CREATE LF INDEX  NumExecs_LF_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  NumExecs  )   "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  PacketsSent_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  PacketsSent  )   "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  PhysicalReads_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  PhysicalReads  )   "   >> ${SQL_FILE}
echo "CREATE LF INDEX  SRVName_LF_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  SRVName  )   "   >> ${SQL_FILE}
echo "CREATE DTTM INDEX  StartTime_DTTM_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  StartTime  )   "   >> ${SQL_FILE}
echo "CREATE HNG INDEX  WaitTime_HNG_idx  ON  mda_user.proc_stats_${SOURCE_SRV}  (  WaitTime  )   "   >> ${SQL_FILE}
echo "END" >> ${SQL_FILE}

##dbisqlc -c "uid=${DEST_USER};pwd=${DEST_PASS};eng=${DEST_SRV}" -q ${SQL_FILE}
dbisqlc -q ${SQL_FILE}


#-------------------------------------------------------------#
# step 4: load TABLE mda_user.proc_stats 
#-------------------------------------------------------------#
SQL_FILE=$SYBMAINT/MDA/${0}.sql.step4.${SOURCE_SRV}


echo "SET TEMPORARY OPTION DATE_ORDER = 'MDY'; " > ${SQL_FILE}
echo "SET TEMPORARY OPTION Date_Format='YYYYMMDD'; " >> ${SQL_FILE}
echo "SET TEMPORARY OPTION Output_Format='TEXT'; " >> ${SQL_FILE}
echo "LOAD TABLE mda_user.proc_stats_${SOURCE_SRV} " >> ${SQL_FILE}
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



