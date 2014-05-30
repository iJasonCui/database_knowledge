#!/bin/bash

if [ $# -ne 1 ] ; then
  echo "Usage: <groupName> "
  exit 1
fi


#
# Initialize arguments
#

DatabaseName=MonitorBackupP
Server=opsdb1p
groupName=${1}
SYBMAILTO=`cat ./mail_${groupName}.list`


. $HOME/.bash_profile
Password=`cat $HOME/.sybpwd | grep -w $Server | awk '{print $2}'`
isql -w10000 -S${Server} -Ucron_sa -P${Password} -o failuresEmail.body.${groupName} <<EOF1
use ${DatabaseName}
go
SELECT "This report ran at "+convert(varchar(50),getdate()) as "Daily Backup Alert Report"
go
SELECT  
alertId,
executionId,
hostName,
jobId,
jobDesc,
groupName,
scheduleId,
scheduleDesc,
dateCreated,
rtrim(Note) as Note
FROM  v_Failures
WHERE
groupName = '${groupName}'
and
dateCreated between dateadd(hh,10,dateadd(dd,-1,convert(varchar(25),getdate(),101)))
and
dateadd(hh,10,dateadd(dd,0,convert(varchar(25),getdate(),101)))
--dateCreated between dateadd(dd,-1,convert(varchar(25),getdate(),101))
--and
--dateadd(dd,0,convert(varchar(25),getdate(),101))
--getdate()

go
EOF1

mail -s "Daily Backup Alert Report From ${DSQUERY}.${DatabaseName} For Group ${groupName}" ${SYBMAILTO} < failuresEmail.body.${groupName}

exit 0
~
~
~
