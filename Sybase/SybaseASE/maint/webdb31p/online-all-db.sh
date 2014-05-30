#!/bin/sh

ServerName=$DSQUERY
LogFile=$SYBMAINT/logs/$0.log
Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`

date > ${LogFile}

for DatabaseName  in `cat dbList`
do

/opt/sybase12_52/OCS-12_5/bin/isql -Usa -S${ServerName} -P${Password} >> ${LogFile} <<EOQ1
online database ${DatabaseName} 
go

EOQ1

done

exit 0

