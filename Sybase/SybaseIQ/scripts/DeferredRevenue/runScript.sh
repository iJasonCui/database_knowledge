#!/bin/sh
if [ $# -ne 4 ] ; then
  echo "Usage: <DBServer> <DBName> <Environment> <LoginName>"
  exit 1
fi

DBServer=$1
DBName=$2
Environment=$3
LoginName=$4

yyyymmddHHMMSS=`date '+%Y%m%d%H%M%S'`
Password=`cat $HOME/.sybpwd | grep $DBServer | awk '{print $2}'`

for i in `cat output/${Environment}ProcList`
do
  echo -n "Processing ${i} from ${DBServer} on ${DBName}"
  logFile=./output/${i}.out.${yyyymmddHHMMSS}.${DBName}.${DBServer}
  isql -U${LoginName} -S${DBServer} -D${DBName} -i ${i}.sql -o ${logFile} -P ${Password}
  cat ${logFile} 
done

exit 0

