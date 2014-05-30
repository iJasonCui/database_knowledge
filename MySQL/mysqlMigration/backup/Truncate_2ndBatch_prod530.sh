RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Content Jump SurveyPoll SuccessStory Tracking ContentStage
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}

mysql -Nse 'show tables' ${DB_NAME} -h10.10.26.40 -P7100 -uroot -p63vette | while read table; do mysql -e "TRUNCATE TABLE  $table" ${DB_NAME} -h10.10.26.40 -P7100 -uroot -p63vette ; done
 
mysql -Nse 'show tables' ${DB_NAME} -h10.10.26.40 -P7100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.10.26.40 -P7100 -uroot -p63vette ; done

done

exit 0

