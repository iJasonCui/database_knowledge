RUN_DATE_TIME=`date '+%Y%m%d_%H%M%S'`
LOG_FILE=./logs/$0.log.${RUN_DATE_TIME}

date > ${LOG_FILE}

for DB_NAME in Msg_ad Msg_ar Msg_ai Msg_md Msg_mr Msg_mi Msg_wd Msg_wr Msg_wi 
do

echo "#-----------------------" >> ${LOG_FILE}
echo "#  "${DB_NAME}  >> ${LOG_FILE}
echo "#-----------------------" >> ${LOG_FILE}
date >> ${LOG_FILE}

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.30 -P4100 -uroot -p63vette | while read table; do mysql -e "truncate table $table" ${DB_NAME} -h10.50.4.30 -P4100 -uroot -p63vette ; done
 
mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.30 -P4100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.30 -P4100 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.40 -P4100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.40 -P4100 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.10.96.221 -P7200 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.10.96.221 -P7200 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.10 -P5100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.10 -P5100 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.20 -P5100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.20 -P5100 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.30 -P5100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.30 -P5100 -uroot -p63vette ; done

mysql -Nse 'show tables' ${DB_NAME} -h10.50.4.40 -P5100 -uroot -p63vette | while read table; do mysql -e "select count(*) from $table" ${DB_NAME} -h10.50.4.40 -P5100 -uroot -p63vette ; done


done

exit 0

