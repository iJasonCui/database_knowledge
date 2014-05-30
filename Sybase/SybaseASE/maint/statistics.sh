#!/bin/sh

. $HOME/.profile

if [ $# != 1 ]
then
   echo "Usage: "${0}" <serverName> "
   exit 1
else
   serverName=${1}
fi

now=`date +%Y%m%d%H%M%S`
workDir=/opt/scripts/statistics/
logFile=${serverName}.${now}
backupDir=/dumps/abuselogs/stats/${serverName}/

Password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`

cd ${workDir}

$SYBASE/bin/isql -S${serverName} -Ucron_sa -P${Password}  -i sp_sysmon.sql -o ${logFile} 

./process_stats_125 ${logFile} 

$SYBASE/bin/bcp stats..parsed_sp_sysmon in ${workDir}/${serverName} -Usa -Pnetgear -Swebstat -c -t "|~" -r "|@|" -e radu.t

mv ${workDir}/${logFile} ${backupDir} 

WhatDay=`date | grep E | cut -c1-3 `

case ${WhatDay} in 
"Sun") 
    /usr/bin/find ${backupDir} -name ${serverName}".*" -mtime +30 -exec rm -f {} \; 2>&1 > /dev/null 
;;

esac

exit
