#!/bin/sh

if [ $# -ne 1 ] ; then
  echo "Usage: <ServerName> "
  exit 1
else
  serverName=${1}
fi

while read lineA
do

   echo $lineA > lineA.txt
   dbName=`cat lineA.txt | awk '{print $1}'`
   sourcePath=`cat lineA.txt | awk '{print $2}'`
   stripeCount=`cat lineA.txt | awk '{print $3}'`

   echo "====================================================" >> ${LogFile}
   echo "[dbName]"${dbName}" [sourcePath]"${sourcePath}" [stripeCount]"${stripeCount} >> ${LogFile} 

   cd /opt/etc/sybase/maint/Refresh 
   ./main-dump-database.sh ${serverName} ${dbName} a > /dev/null 2>&1
 
done < DBDumpConfig.ini 


exit 0

