#!/bin/sh

. $HOME/.bash_profile

#if [ $# -ne 6 ] ; then
#  echo "Usage: <JobId> <scheduleId> <executionNote> <executionStatus> <jobSpecificCode> <logLocation >"
#  exit 1
#fi


#
# Initialize arguments
#

DatabaseName=MonitorBackupD
Server=opsdb1p



. /home/sybase/.bash_profile 
Password=`cat $HOME/.sybpwd | grep $DSQUERY | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -S${Server} -Ucron_sa -P${Password} <<EOF1
select getdate()
go

use ${DatabaseName}
go

exec  bsp_AddAlerts

go
select getdate()
go

EOF1

exit 0
~
~
~
