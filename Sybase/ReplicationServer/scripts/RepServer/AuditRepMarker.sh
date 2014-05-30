#!/bin/bash

if [ $# -ne 2 ]
then
   echo "Usage: ${0} <ActiveDBServerName> <StandbyDBServerName>"
   exit 1
else
   ActiveDBServerName=${1} 
   StandbyDBServerName=${2}
fi

UserName=cron_sa
ProcessedDateTime=`date '+%Y%m%d_%H%M%S'`
LogFile=./output/${0}.log.${ActiveDBServerName}.${StandbyDBServerName}.${ProcessedDateTime}

Password_A=`cat $HOME/.sybpwd | grep -w ${ActiveDBServerName} | awk '{print $2}'`
Password_S=`cat $HOME/.sybpwd | grep -w ${StandbyDBServerName} | awk '{print $2}'`
#PasswordRep=`cat $HOME/.sybpwd | grep -w ${RepServerName} | awk '{print $2}'`

date > ${LogFile}

for serverName in ${ActiveDBServerName} ${StandbyDBServerName}
do

echo "===================================" >> ${LogFile}
echo "[serverName] "${serverName}          >> ${LogFile} 
echo "===================================" >> ${LogFile}
echo "dbcc gettrunc  " >> ${LogFile}
echo "===================================" >> ${LogFile}

Password=`cat $HOME/.sybpwd | grep ${serverName} | awk '{print $2}'`

sqsh -U${UserName} -P${Password} -S${serverName} <<EOQ1 >> ${LogFile}

set nocount on
go

SELECT name from master..sysdatabases where name not in ("master", "model", "tempdb", "sybsystemdb", "sybsystemprocs", "dbload",\
       "sybsyntax" )
\do

   \echo #1
   use #1
   go

   dbcc gettrunc   
   go

\done


EOQ1

done #### the loop for server

cat ${LogFile} 

exit 0

