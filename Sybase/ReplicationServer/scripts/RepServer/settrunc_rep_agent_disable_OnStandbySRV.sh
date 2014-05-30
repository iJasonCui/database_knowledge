#!/bin/sh

if [ $# -ne 2 ] ; then
  echo "Usage: ${0} <serverName> <DBName> "
  exit 1
fi

serverName=${1}
DBName=${2}
LoginName=cron_sa

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

logFile=output/${0}.out.${ProcessedDateTime}.${serverName}.${repSRV}.${DBName}

Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

date > ${logFile}
echo "==== step 1: make activeDB as dbo use only ==========" >> ${logFile}

isql -U${LoginName} -S${serverName} -P ${Password} >> ${logFile} <<EOQ1

USE ${DBName}
go

dbcc settrunc('ltm', ignore)
go

exec sp_config_rep_agent ${DBName}, disable
go

EOQ1

cat ${logFile}
exit 0

