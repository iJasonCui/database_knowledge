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
# bcp out PrimaryDB list 
#-------------------------------------#

bcp ${OPS_DB}..v_PrimaryDB  out v_PrimaryDB.ini -U${OPS_DB_USER} -P${OPS_PASSWORD} -S${OPS_DB_SRV} -c  

#----------------------------------------------------------------------------------------------------------#
# measure the latency happened one hour ago with excluding the system time disrepancy between UNIX servers 
#----------------------------------------------------------------------------------------------------------# 

while read j
do

echo ${j} > v_PrimaryDB.tmp

PRIM_DB_ID=`cat v_PrimaryDB.tmp | awk '{print $1}'`
PRIM_DB_NAME=`cat v_PrimaryDB.tmp | awk '{print $2}'`
PRIM_SRV_NAME=`cat v_PrimaryDB.tmp | awk '{print $3}'`
PRIM_DB_USER=`cat v_PrimaryDB.tmp | awk '{print $4}'`
PRIM_PASSWORD=`cat v_PrimaryDB.tmp | awk '{print $5}'`
##PRIM_PASSWORD=`cat $HOME/.pwd_webmaint | grep -w ${PRIM_SRV_NAME} | awk '{print $2}'`
##PRIM_DB_USER="webmaint"

isql -U${PRIM_DB_USER} -S${PRIM_SRV_NAME} -P${PRIM_PASSWORD} -D${PRIM_DB_NAME} << EOF1 
set nocount on
exec wsp_newRepTest
go
EOF1

done < ${WORK_DIR}/v_PrimaryDB.ini  ##  the end of loop j

exit 0


