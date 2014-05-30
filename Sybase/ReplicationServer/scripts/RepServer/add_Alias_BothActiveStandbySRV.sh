#!/bin/sh

if [ $# -ne 3 ] ; then
  echo "Usage: ${0} <serverName> <repSRV> <DBName> "
  exit 1
fi

serverName=${1}
repSRV=${2}
DBName=${3}
LoginName=cron_sa
repMaintUser=${repSRV}_maint_user

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

logFile=output/${0}.out.${ProcessedDateTime}.${serverName}.${repSRV}.${DBName}

Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

date > ${logFile}
echo "==== step 1: make activeDB as dbo use only ==========" >> ${logFile}

isql -U${LoginName} -S${serverName} -P ${Password} >> ${logFile} <<EOQ1

USE ${DBName}
go
IF USER_ID('${repMaintUser}') IS NOT NULL
BEGIN
    EXEC sp_dropuser '${repMaintUser}'
    IF USER_ID('${repMaintUser}') IS NOT NULL
        PRINT '<<< FAILED DROPPING USER ${repMaintUser} >>>'
    ELSE 
        PRINT '<<< DROPPED USER ${repMaintUser} >>>'
END
go

USE ${DBName}
go
EXEC sp_addalias '${repMaintUser}','dbo'
go

EOQ1

cat ${logFile}
exit 0

