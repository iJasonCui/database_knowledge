#!/bin/sh
if [ $# -ne 4 ] ; then
  echo "Usage: <DBServer> <DBName> <Environment> <LoginName>"
  exit 1
fi

DBServer=$1
DBName=$2
Environment=$3
LoginName=$4

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
Password=`cat $HOME/.sybpwd | grep -w $DBServer | awk '{print $2}'`

for i in `cat output/${Environment}List`
do
  echo "====================================================" 
  echo -n "Processing ${i} from ${DBServer} on ${DBName}"
  logFile=./output/${i}.out.${ProcessedDateTime}.${DBName}.${DBServer}
  isql -U${LoginName} -S${DBServer} -D${DBName} -i ${i}.sql -o ${logFile} -P ${Password}
  cat ${logFile} 
done

exit 0

