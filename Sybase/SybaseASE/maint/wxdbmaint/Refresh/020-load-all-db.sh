#!/bin/sh

if [ $# -ne 1 ] ; then
  echo "Usage: <ServerName> "
  exit 1
else
  serverName=${1}
fi

while read lineA
do

   LogFile=$SYBMAINT/web/Refresh/logs/$0.log
   echo $lineA > lineA.txt
   dbName=`cat lineA.txt | awk '{print $1}'`
   sourcePath=`cat lineA.txt | awk '{print $2}'`
   stripeCount=`cat lineA.txt | awk '{print $3}'`

   echo "====================================================" >> ${LogFile}
   echo "[dbName]"${dbName}" [sourcePath]"${sourcePath}" [stripeCount]"${stripeCount} >> ${LogFile} 

   #cd /opt/etc/sybase12_52/maint/Refresh 
   cd $SYBMAINT/web/Refresh 
   ############ added this condition because we only have CreditCard and CCEncrypted
   ############ Database on 0t   20080605 
   #if [ $serverName = webdb0g -a \( $dbName = CreditCard  -o $dbName = CCEncrypted \) ]
   #then
   #  continue
   #fi 
   #echo ${serverName} ${dbName}
   ./main-load-database.sh ${serverName} ${dbName} a > /dev/null 2>&1
done < DBLoadConfig.ini 


exit 0

