#!/bin/sh

if [ $# -ne 6 ] ; then
  echo "Usage: <JobId> <scheduleId> <executionNote> <executionStatus> <jobSpecificCode> <logLocation >"
  exit 1
fi


#
# Initialize arguments
#

DatabaseName=MonitorBackupP
Server=opsdb1p
JobId=$1
scheduleId=$2
executionNote=$3
executionStatus=$4
jobSpecificCode=$5
logLocation=$6



. /opt/sybase/SYBASE.sh

Password=`cat $HOME/.sybpwd | grep opsdb1p | awk '{print $2}'`
$SYBASE/$SYBASE_OCS/bin/isql -S${Server} -Ucron_sa -P${Password} <<EOF1
use ${DatabaseName}
go
--PRINT  "${JobId}  ${scheduleId}  ${executionNote}  ${executionStatus}  ${jobSpecificCode}  ${logLocation}"
go
DECLARE @sId int

SELECT @sId= CASE WHEN ${scheduleId} = 0 THEN Null ELSE ${scheduleId} END

exec  bsp_ExecutionI
@executionId=0
,@scheduleId=@sId
,@createdBy=9999
,@executionNote="${executionNote}"
,@logLocation="${logLocation}"
,@executionStatus=${executionStatus}
,@jobSpecificCode=${jobSpecificCode}
,@jobId=${JobId}

go
EOF1

exit 0

