#!/bin/bash

RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Content Jump SurveyPoll 
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}
  
./dataMigrationSybMysql.sh  w151dbp01 ${DB_NAME} 10.50.4.10 4100 ${DB_NAME}

done

./dataMigrationSybMysql.sh  w151dbp01 Content 10.50.4.10 4100  ContentStage

for DB_NAME in SuccessStory Tracking
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}

./dataMigrationSybMysql.sh  w151dbp02 ${DB_NAME} 10.50.4.10 4100 ${DB_NAME}

done

echo "#-----------------------" >> ${LOG_FILE}
echo "#   completed " >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}

exit 0


