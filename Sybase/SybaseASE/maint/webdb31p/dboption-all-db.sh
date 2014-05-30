#!/bin/sh

ServerName=$DSQUERY
LogFile=$SYBMAINT/logs/$0.log
Password=`cat $HOME/.sybpwd | grep -w ${ServerName} | awk '{print $2}'`

date > ${LogFile}

for DatabaseName  in `cat dbList`
do

/opt/sybase12_52/OCS-12_5/bin/isql -Usa -S${ServerName} -P${Password} >> ${LogFile} <<EOQ1
USE master
go
EXEC sp_dboption '${DatabaseName}','trunc log on chkpt',false
go
USE ${DatabaseName} 
go
CHECKPOINT
go

sp_helpdb ${DatabaseName}
go

EOQ1

done

exit 0

