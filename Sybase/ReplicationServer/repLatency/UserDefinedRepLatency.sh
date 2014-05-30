#!/bin/bash

. $HOME/.bash_profile

#---------------------------------------------------------------------------------#
# UserDefinedRepLatency.sh is created by Jason C. on Mar 20 2006.
# This script is used for measuring Rep System Latency. The method is described as below:
# 1. create RepTest table on primary db 
# 2. create RepTest table with an extra column (datatype as Datetime, default as GETDATE()) on each related replicate DBs  
# 3. insert a testing row into RepTest on primary db
# 4. figuring out the latency with taking the system time discrepancy into account  
#----------------------------------------------------------------------------------#

OPS_DB_SRV="opsdb2p"
OPS_DB_USER="cron_sa"
OPS_DB="repStats"
OPS_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_DB_SRV} | awk '{print $2}'`

PRIM_DB_SRV="webdb29p"
PRIM_DB_USER="cron_sa"
PRIM_PASSWORD=`cat $HOME/.sybpwd | grep -w ${PRIM_DB_SRV} | awk '{print $2}'`

REP_DB_USER="cron_sa"

WORK_DIR=${SYBMAINT}/repLatency
LOG_FILE=${0}.log

cd ${WORK_DIR}

#-------------------------------------#
# bcp out serverList and DB list      #
#-------------------------------------#

bcp ${OPS_DB}..ReplicateDB_SRV out ReplicateDB_SRV.ini -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV} -c  
bcp ${OPS_DB}..ReplicateDB out ReplicateDB.ini -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV} -c

#----------------------------------------------------------------------------------------------------------#
# measure the latency happened one hour ago with excluding the system time disrepancy between UNIX servers 
#----------------------------------------------------------------------------------------------------------# 

while read j
do

echo ${j} > ReplicateDB_SRV.tmp

DB_SRV_ID=`cat ReplicateDB_SRV.tmp | awk '{print $1}'`
DB_SRV_NAME=`cat ReplicateDB_SRV.tmp | awk '{print $2}'`
REP_DB_SRV_PASSWORD=`cat $HOME/.sybpwd | grep -w ${DB_SRV_NAME} | awk '{print $2}'`

PRIM_DB_SRV_TIME=`isql -U${PRIM_DB_USER} -S${PRIM_DB_SRV} -w160 <<- EOF2 | sed '1,3d'
${PRIM_PASSWORD}
set nocount on
SELECT DATEDIFF(ss, "Jan 1 1970", GETDATE()) 
go
exit
EOF2`

echo ${PRIM_DB_SRV_TIME}

REP_DB_SRV_TIME=`isql -U${REP_DB_USER} -S${DB_SRV_NAME} -w160 <<- EOF3 | sed '1,3d'
${REP_DB_SRV_PASSWORD}
set nocount on
SELECT DATEDIFF(ss, "Jan 1 1970", GETDATE())
go
exit
EOF3`

echo ${REP_DB_SRV_TIME}

while read i
do

echo ${i} > ReplicateDB.tmp

DB_ID=`cat ReplicateDB.tmp | awk '{print $1}'`
DB_NAME=`cat ReplicateDB.tmp | awk '{print $2}'`

REP_TEST_ID_PREVIOUS=` cat repTestId.ini.${DB_NAME} `

sqsh -U${REP_DB_USER} -S${DB_SRV_NAME} -P${REP_DB_SRV_PASSWORD} << EOF4 
set nocount on
SELECT ${DB_SRV_ID} AS serverId, 
       ${DB_ID}     AS databaseId, 
       datediff(ss,dateTime,defaultDateTime) - (${REP_DB_SRV_TIME} - ${PRIM_DB_SRV_TIME}) AS latencyInSec,
       dateadd(hh, -1, dateadd(ss, ${PRIM_DB_SRV_TIME}, "Jan 1 1970")) AS dataCreated            
FROM ${DB_NAME}..RepTest
WHERE repTestId = ${REP_TEST_ID_PREVIOUS} 
\bcp ${OPS_DB}..UserDefinedRepLatency -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV}  
go
EOF4

done < ${WORK_DIR}/ReplicateDB.ini  ##  the end of loop i

done < ${WORK_DIR}/ReplicateDB_SRV.ini  ##  the end of loop j

#------------------------------------------------#
# insert a row into RepTest on Primary db server #
#------------------------------------------------#

while read i
do

echo ${i} > ReplicateDB.tmp

DB_ID=`cat ReplicateDB.tmp | awk '{print $1}'`
DB_NAME=`cat ReplicateDB.tmp | awk '{print $2}'`
 
REP_TEST_ID=`isql -U${PRIM_DB_USER} -S${PRIM_DB_SRV} -w160 <<- EOF1 | sed '1,3d' 
${PRIM_PASSWORD}
set nocount on  
use ${DB_NAME} 
go
DECLARE @max_repTestId    int
SELECT  @max_repTestId = MAX(repTestId) FROM RepTest 
INSERT RepTest (repTestId, dateTime) VALUES (@max_repTestId+1, GETDATE())
select @max_repTestId+1
go
exit  
EOF1`

echo ${REP_TEST_ID} > repTestId.ini.${DB_NAME} 
 
done < ${WORK_DIR}/ReplicateDB.ini

exit 0


