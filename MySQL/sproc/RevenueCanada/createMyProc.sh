#!/bin/sh
if [ $# -ne 4 ] ; then
  echo "Usage: <DB_SERVER_IP> <DB_SERVER_PORT> <DB_NAME> <Environment> "
  exit 1
fi

DB_SERVER_IP=$1
DB_SERVER_PORT=$2
DB_NAME=$3
Environment=$4
USER=root

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
PASSWORD=`cat $HOME/.mysqlpwd | grep -w ${DB_SERVER_IP} | grep -w ${DB_SERVER_PORT} | awk '{print $3}'`

for i in `cat output/${Environment}List`
do
  echo "#-------------------------------"   
  echo "Processing ${i} from ${DB_SERVER_IP} port ${DB_SERVER_PORT} on ${DB_NAME}"
  LOG_FILE=output/${i}.out.${ProcessedDateTime}.${DB_SERVER_IP}.${DB_NAME}

  mysql -h${DB_SERVER_IP} -P${DB_SERVER_PORT} -D${DB_NAME} -u${USER} --password=${PASSWORD} < $i.mysql >${LOG_FILE}

done

echo "#-------------------------------"
exit 0


