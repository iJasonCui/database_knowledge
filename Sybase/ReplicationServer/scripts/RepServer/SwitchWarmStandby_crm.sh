#!/bin/sh

if [ $# -ne 7 ] ; then
  echo "Usage: ${0} <activeSRV> <standbySRV> <repSRV> <logicalSRV> <DBName> <activeSRVForRep> <standbySRVForRep> "
  exit 1
fi

activeSRV=${1}
standbySRV=${2}
repSRV=${3}
logicalSRV=${4}
DBName=${5}
activeSRVForRep=${6}
standbySRVForRep=${7}
LoginName=cron_sa
repLogin=sa

ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`

logFile=output/${0}.out.${ProcessedDateTime}.${activeSRV}.${standbySRV}.${repSRV}.${logicalSRV}.${DBName}
RepServerStatus=RepServerStatus.${DBName}.out

PasswordActive=`cat $HOME/.sybpwd | grep -w ${activeSRV} | awk '{print $2}'`
PasswordStandby=`cat $HOME/.sybpwd | grep -w ${standbySRV} | awk '{print $2}'`
PasswordRep=`cat $HOME/.sybpwd | grep -w ${repSRV} | awk '{print $2}'`

date > ${logFile}
echo "==== step 1: make activeDB as dbo use only and kill web connection to this DB ==========" >> ${logFile}

isql -U${LoginName} -S${activeSRV} -P ${PasswordActive} >> ${logFile} <<EOQ1
USE master
go
EXEC sp_dboption ${DBName},'dbo use only',true
go
USE ${DBName}
go
CHECKPOINT
go

use master
go

exec sp_kill_process ${DBName}, x2kcco       
go

exec sp_kill_process ${DBName}, x2k900
go

exec sp_kill_process ${DBName}, smsuser     
go

EOQ1

date >> ${logFile}
echo "==== step 2:  stop rep agent on the activeDB  ==========" >> ${logFile} 

isql -U${LoginName} -S${activeSRV} -P ${PasswordActive} >> ${logFile} <<EOQ2
use ${DBName}
go
exec sp_stop_rep_agent ${DBName}
go 
EOQ2

date >> ${logFile}
echo "==== step 3:  switch over the active and standby  ==========" >> ${logFile}

isql -U${repLogin} -S${repSRV} -P ${PasswordRep} >> ${logFile} <<EOQ3
switch active for ${logicalSRV}."${DBName}" to ${standbySRVForRep}."${DBName}" with suspension
go
EOQ3

date >> ${logFile}

echo "==== step 3.1:  check whether the switch over finished or not  ==========" >> ${logFile}

repAgentDown0=${standbySRVForRep}.${DBName}
repAgentDown="none"

echo "=======================" >> ${logFile}
echo ${repAgentDown}  >> ${logFile}
echo ${repAgentDown0} >> ${logFile}

while  [ "${repAgentDown}" != "${repAgentDown0}" ]
do

   echo "====== while =================" >> ${logFile}
   echo ${repAgentDown}  >> ${logFile} 
   echo ${repAgentDown0} >> ${logFile}

   if [ -s ${RepServerStatus} ]
   then
      rm ${RepServerStatus}
   fi

   sleep 30

isql -U${repLogin} -S${repSRV} -P ${PasswordRep} > ${RepServerStatus} <<EOQ31
admin who_is_down
go

EOQ31

repAgentDown=`grep "REP AGENT" ${RepServerStatus} | awk '{print $4}' `

done


echo "==== step 4:  start up the rep agent on the new active db  ==========" >> ${logFile}

isql -U${LoginName} -S${standbySRV} -P ${PasswordStandby} >> ${logFile} <<EOQ4
use ${DBName}
go
exec sp_start_rep_agent ${DBName}
go
EOQ4

date >> ${logFile}
echo "==== step 5:  resume the connection to the new standby db  ==========" >> ${logFile}

isql -U${repLogin} -S${repSRV} -P ${PasswordRep} >> ${logFile} <<EOQ5
resume connection to "${standbySRVForRep}"."${DBName}"
go
resume connection to "${activeSRVForRep}"."${DBName}" 
go
EOQ5

date >> ${logFile}
echo "==== step 6:  please test the rep system and then turn off 'dbo use only' on the new active db  ==========" >> ${logFile}

isql -U${LoginName} -S${standbySRV} -P ${PasswordStandby} >> ${logFile} <<EOQ6
USE master
go
EXEC sp_dboption ${DBName},'dbo use only',false
go
USE ${DBName}
go
CHECKPOINT
go
EOQ6


cat ${logFile} 

exit 0

