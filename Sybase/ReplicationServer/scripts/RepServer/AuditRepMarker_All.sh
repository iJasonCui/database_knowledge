#!/bin/sh

DB_SERVER_LIST=RepSystem.ini

while read dbServerList
do

   echo ${dbServerList} > dbServer.line
  
   ACTIVE_DB_SRV=`cat dbServer.line | awk '{print $1}'` 
   STANDBY_DB_SRV=`cat dbServer.line | awk '{print $2}'`  

   ./AuditRepMarker.sh ${ACTIVE_DB_SRV} ${STANDBY_DB_SRV}

done < ${DB_SERVER_LIST}

exit 0


