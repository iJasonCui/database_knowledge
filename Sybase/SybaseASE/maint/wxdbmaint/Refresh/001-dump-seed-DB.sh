#!/bin/sh

if [ $# -ne 1 ] ; then
  echo "Usage: <ServerName> "
  exit 1
else
  serverName=${1}
  password=`cat $HOME/.sybpwd | grep -w ${serverName} | awk '{print $2}'`
  user=sa
fi

grep "/usr/l/data/dump/seed_db" DBLoadConfig.ini > DBSeedDumpConfig.ini

while read lineA
do

   echo $lineA > lineA.txt
   dbName=`cat lineA.txt | awk '{print $1}'`
   sourcePath=`cat lineA.txt | awk '{print $2}'`
   stripeCount=`cat lineA.txt | awk '{print $3}'`

   echo "====================================================" >> ${LogFile}
   echo "[dbName]"${dbName}" [sourcePath]"${sourcePath}" [stripeCount]"${stripeCount} >> ${LogFile} 

   cd /opt/etc/sybase12_52/maint/Refresh 

sqsh -U${user} -S${serverName} -P${password} >> ${LogFile} << EOQ1

dump database ${dbName} to "${sourcePath}/${dbName}/${dbName}-dba-1"  
go

EOQ1
 
done < DBSeedDumpConfig.ini 


exit 0

