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

OPS_DB_SRV="g151opsdb02"
OPS_DB_USER="cron_sa"
OPS_DB="repStats"
OPS_PASSWORD=`cat $HOME/.sybpwd | grep -w ${OPS_DB_SRV} | awk '{print $2}'`

WORK_DIR=${SYBMAINT}/repLatency
LOG_FILE=${0}.log

cd ${WORK_DIR}

#-------------------------------------#
# bcp out serverList and DB list      #
#-------------------------------------#

bcp ${OPS_DB}..v_ReplicateDB  out v_ReplicateDB.ini -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV} -c

#----------------------------------------------------------------------------------------------------------#
# measure the latency happened one hour ago with excluding the system time disrepancy between UNIX servers 
#----------------------------------------------------------------------------------------------------------# 

while read j
do

echo ${j} > ReplicateDB_SRV.tmp


REP_DB_ID=`cat ReplicateDB_SRV.tmp | awk '{print $1}'`
REP_DB_NAME=`cat ReplicateDB_SRV.tmp | awk '{print $2}'`
REP_DB_SRV_NAME=`cat ReplicateDB_SRV.tmp | awk '{print $3}'`
PRIM_DB_SRV_NAME=`cat ReplicateDB_SRV.tmp | awk '{print $4}'`

REP_DB_USER="cron_sa"
REP_DB_PASSWD=`cat $HOME/.sybpwd | grep -w ${REP_DB_SRV_NAME} | awk '{print $2}'`

PRIM_DB_USER="cron_sa"
PRIM_DB_PASSWD=`cat $HOME/.sybpwd | grep -w ${PRIM_DB_SRV_NAME} | awk '{print $2}'`

MAX_REP_TEST_ID=`isql -U${OPS_DB_USER} -S${OPS_DB_SRV} -D${OPS_DB} -w160 <<- EOF1 | sed '1,3d'
${OPS_PASSWORD}
set nocount on
SELECT ISNULL(MAX(repTestId), 0) FROM ${OPS_DB}..RepLatencyLog WHERE replicateDBId = ${REP_DB_ID} 
go
exit
EOF1`

echo ${MAX_REP_TEST_ID}

PRIM_SRV_TIME=`isql -U${PRIM_DB_USER} -S${PRIM_DB_SRV_NAME} -w160 <<- EOF2 | sed '1,3d'
${PRIM_DB_PASSWD}
set nocount on
SELECT DATEDIFF(ss, "Jan 1 1970", GETDATE()) 
go
exit
EOF2`

echo ${PRIM_SRV_TIME}

REP_SRV_TIME=`isql -U${REP_DB_USER} -S${REP_DB_SRV_NAME} -w160 <<- EOF3 | sed '1,3d'
${REP_DB_PASSWD}
set nocount on
SELECT DATEDIFF(ss, "Jan 1 1970", GETDATE())
go
exit
EOF3`

echo ${REP_SRV_TIME}

sqsh -U${REP_DB_USER} -S${REP_DB_SRV_NAME} -P${REP_DB_PASSWD} -D${REP_DB_NAME} << EOF4 
set nocount on
SELECT 
       ${REP_DB_ID}     AS replicateDBId, 
       datediff(ss,dateTime,defaultDateTime) - (${REP_SRV_TIME} - ${PRIM_SRV_TIME}) AS latencyInSec,
       repTestId,
       dateTime AS dateCreatedPrimary 
FROM ${REP_DB_NAME}..RepTest
WHERE repTestId >  ${MAX_REP_TEST_ID} 
\bcp ${OPS_DB}..RepLatencyLog -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV}  
go
EOF4

done < ${WORK_DIR}/v_ReplicateDB.ini  ##  the end of loop j


exit 0


