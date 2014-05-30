#!/bin/bash

RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Profile_ad Profile_ar Profile_ai  
do
   echo "#-----------------------" >> ${LOG_FILE}
   echo "#  "${DB_NAME}  >> ${LOG_FILE}
   echo "#-----------------------" >> ${LOG_FILE}
   date >> ${LOG_FILE}
  
   ./dataMigrationSybMysql.sh  w151dbp07 ${DB_NAME} 10.50.4.30 4100 ${DB_NAME}
done

for DB_NAME in Profile_md Profile_mr Profile_mi Profile_wd Profile_wr Profile_wi
do
   echo "#-----------------------" >> ${LOG_FILE}
   echo "#  "${DB_NAME}  >> ${LOG_FILE}
   echo "#-----------------------" >> ${LOG_FILE}
   date >> ${LOG_FILE}

   ./dataMigrationSybMysql.sh  w151dbp02 ${DB_NAME} 10.50.4.30 4100 ${DB_NAME}
done

exit 0


