#!/bin/bash

RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Msg_ad Msg_ar Msg_ai Msg_md Msg_mr Msg_mi Msg_wd Msg_wr Msg_wi 
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}
  
./dataMigrationSybMysql.sh  webdb1d  ${DB_NAME} 10.50.4.30 4100 ${DB_NAME}

done

exit 0


