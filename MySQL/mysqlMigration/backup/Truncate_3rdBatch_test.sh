RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Msg_ad Msg_ar Msg_ai Msg_md Msg_mr Msg_mi Msg_wd Msg_wr Msg_wi   
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}

mysql -Nse 'show tables' ${DB_NAME} -h10.20.1.50 -P5010 -uroot -p63vette | while read table; do mysql -e "truncate table $table" ${DB_NAME} -h10.20.1.50 -P5010 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.20.1.50 -P5010 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.20.1.50 -P5010 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.20.1.50 -P5020 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.20.1.50 -P5020 -uroot -p63vette ; done

done

exit 0

