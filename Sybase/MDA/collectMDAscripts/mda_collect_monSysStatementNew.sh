#!/bin/bash

#=====================================================================
# Script Name : mda_collect_monSysStatement.sh
#
# Purpose: Inserts data into MDA Historical table
#
#=====================================================================

. $HOME/.bash_profile

cd $SYBMAINT

trap 'rm /tmp/*.$$ 1>/dev/null 2>&1' EXIT INT QUIT KILL TERM

if [ $# -ne 1 ] ; then
  echo "**********************************************************"
  echo "Usage: $0 <ServerName> "
  echo "**********************************************************"
  exit 1
fi

## Source the Sybase environment

echo "Collecting Information for monSysStatement"

SERVER_NAME=$1
PASSWD=`cat $HOME/.sybpwd | grep -w ${SERVER_NAME} | awk '{print $2}'`
USERNAME=mda_user
LOG_FILE=${SYBMAINT}/MDA/logs/mda_collect_monSysStatement.log.${SERVER_NAME}

isql -U${USERNAME} -P${PASSWD} -S${SERVER_NAME} -w1000 << EOF > ${LOG_FILE} 
select @@version
go
set nocount on
go
declare @dateCreated     datetime
declare @output        varchar(1024)
declare @dbid          int
declare @procedureID   int
declare @query_text    varchar(1024)
declare @rptline       char(255)
declare @rtnstatus     int
declare @averages      int
declare @detail        int
declare @sqlmsg        char(255)
declare @cursprocname  varchar(30)
declare @myobjid       int
declare @sybprocs_dbid int

--select @sybprocs_dbid = db_id('sybsystemprocs') 
-- 
-- select @myobjid = id
--   from sybsystemprocs..sysobjects
--  where name = 'sp__proc_stats'
--    and type = 'P'

select @cursprocname = "procedure"

exec @rtnstatus = sp_monitor_verify_cfgval @cursprocname 
if (@rtnstatus = 1)
   return

declare @counter int
select @counter=1
while (@counter = 1)
begin
begin tran
--      select @dateCreated = max(StartTime) 
--       from mda_db..proc_stats 
        
       select @dateCreated = getdate()
       
       insert mda_db..proc_stats 
       select 
        SRVName = isnull(@@servername, "UNKNOWN"),
        ProcName = isnull(object_name(ProcedureID, DBID), "UNKNOWN"),
        DBName = isnull(db_name(DBID), "UNKNOWN"),
        SPID,
        DBID,
        ProcedureID,
        BatchID,
        CpuTime = sum(1.0*CpuTime),
        WaitTime = sum (1.0*WaitTime),
        PhysicalReads = sum(1.0*PhysicalReads),
        LogicalReads =  sum(1.0*LogicalReads),
        PacketsSent = sum(1.0*PacketsSent),
        StartTime,
        EndTime = max(EndTime),
        ElapsedTime = datediff(ms, min(StartTime), max(EndTime)),
        dateCreated = getdate(),
        NumExecs = 1
FROM  master..monSysStatement
WHERE ProcedureID != 0
  AND DBID not in (db_id('master'), db_id('sybsystemprocs') ,db_id('tempdb'))
  AND StartTime < EndTime
GROUP BY SPID, DBID, ProcedureID, BatchID, StartTime
   
   if @@error != 0  or @@transtate = 3 
   begin
        print "ERROR : insert into ..proc_stats failed "
        if @@trancount > 0  rollback tran
        select @counter = -1
        return
   end
   commit tran

--select @dateCreated = max(dateCreated) from mda_db..proc_stats 
select "last insert" = convert(char(20),@dateCreated, 108) 
waitfor delay '00:01:00'
end
go
exit
EOF
