set rowcount 20

select * from mda_db..proc_stats a where a.LogicalReads > 10000 order by a.LogicalReads desc

 

set rowcount 0

--select * from mda_db..proc_stats a where a.ProcName = "gsp_getTrialSessionsApproved" order by a.LogicalReads desc

 

set rowcount 10

select * from mda_db..proc_stats a where a.ProcName = "gsp_getSpecificPicture" order by a.LogicalReads desc

 

select "select * from " + TableName  from master..monTables

select * from master..monTableColumns c where c.Description like "%para%"

 

select * from master..monTables 

select * from monTableParameters

select * from master..monTableColumns c where c.TableName = 'monSysStatement'

select * from monState

select * from monEngine

select * from monDataCache

select * from monProcedureCache

select * from monProcedureCacheMemoryUsage

select * from monProcedureCacheModuleUsage

select * from monOpenDatabases

select * from monSysWorkerThread

select * from master..monNetworkIO

select * from monErrorLog

select * from monLocks

select * from monDeadLock

select * from master..monWaitClassInfo

select * from master..monWaitEventInfo

select * from monCachedObject

select * from monCachePool

select * from monOpenObjectActivity o order by o.LogicalReads desc

select * from master..monOpenObjectActivity o 
where DBName = 'nycNE' and ObjectID = 432004570 --ObjectName = 'user_info' 
order by o.PhysicalReads desc

select * from master..monOpenObjectActivity o 
where DBName = 'nycNE' and ObjectName = 'user_info' 
--order by o.PhysicalReads desc
order by o.LogicalReads desc

sp_helpindex user_info

sp_helpindex Picture

select *, IOTime/IOs from master..monIOQueue

select * from master..monDeviceIO order by IOTime desc 
select * from master..monDeviceIO order by Reads desc 
select * from master..monDeviceIO order by Writes desc 

select e.Description, w.* 
from master..monSysWaits w, master..monWaitEventInfo e 
where w.WaitEventID = e.WaitEventID order by w.WaitTime desc

select * from monProcess 

select * from monProcessLookup 

select * from monProcessActivity 

select * from monProcessWorkerThread 

select * from monProcessNetIO 

select * from monProcessObject

select * from monProcessWaits

select * from monProcessStatement
set rowcount 1
select * from master..monSysStatement s
where DBID = db_id('torLL') and s.ProcedureID > 0 order by s.EndTime desc

select * from master..monSysStatement s
where DBID = db_id('Profile_ad') --and s.ProcedureID > 0 order by s.EndTime desc



select * from master..monProcessSQLText where SPID = 1665 and BatchID = 16

select * from master..monSysSQLText t --order by t.SPID, t.BatchID, t.SequenceInBatch 
where t.SPID = 1665 and t.BatchID = 16 -- and t.KPID =  

select * from monCachedProcedures

select * from monProcessProcedures

select * from master..monSysPlanText

select * from monOpenPartitionActivity op where op.DBName = "stlLL" order by op.LogicalReads 

select * from monLicense

select * from monStatementCache

select * from monCachedStatement

select * from master..monOpenObjectActivity

select * from master..monSysSQLText t where t.SQLText like "%Mailbox% " order by t.BatchID

select * from master..monSysSQLText t where t.SPID = 2648 and t.BatchID = 6
select * from master..monSysStatement t where t.SPID = 2648 and t.BatchID = 6

select * from mda_db..monSysSQLText b where b.serverUserName = "x2kivr"


--==========================================  
--slow query   
select * into tempdb..TmonSysStatement from master..monSysStatement 
select * into tempdb..TmonSysSQLText   from master..monSysSQLText 
select * into tempdb..TmonSysPlanText  from master..monSysPlanText 

SELECT object_name(ProcedureID), datediff(ms, StartTime, EndTime), * FROM tempdb..TmonSysStatement s
WHERE  s.DBID = db_id('nycNE') and ProcedureID = object_id("gsp_getTrialSessionsApproved")
 -- and  s.SPID = 34 
 -- and  s.BatchID = 19
ORDER BY SPID, DBID, ProcedureID, BatchID, StartTime, LineNumber

SELECT * FROM tempdb..TmonSysSQLText t
WHERE  KPID = 1884425795

t.SPID = 34 
  and  t.BatchID = 19
--ORDER BY SPID, DBID, ProcedureID, BatchID 


SELECT s.* , t.*
FROM tempdb..TmonSysStatement s, tempdb..TmonSysSQLText t
WHERE  s.DBID = db_id('nycNE') and s.ProcedureID = object_id("gsp_getTrialSessionsApproved")
  AND  s.SPID = 34 and s.SPID = t.SPID --and s.SPID = p.SPID 
  AND  s.BatchID = 19 and s.BatchID = t.BatchID --and s.BatchID = p.BatchID 
  
ORDER BY SPID, DBID, ProcedureID, BatchID 

select s.*, t.*, p.*
from tempdb..TmonSysStatement s, tempdb..TmonSysSQLText t, tempdb..TmonSysPlanText p
where s.SPID = t.SPID and s.SPID = p.SPID --and s.SPID = 2648
  and s.BatchID = t.BatchID and s.BatchID = p.BatchID --and s.BatchID = 6
  and s.DBID = db_id('nycNE') --and s.ProcedureID = object_id("gsp_getTrialSessionsApproved")
 
--end of slow query   
--===========================================

--===========================================
-- unused index 
--===========================================

-- find seemingly unused indexes in the current database:
select "Database" = db_name(DBID), 
       "Table" = object_name(ObjectID, DBID),
       IndID = IndexID, si.name, 
       oa.UsedCount,
       oa.OptSelectCount,
       oa.LastOptSelectDate,
       oa.LastUsedDate
from master..monOpenObjectActivity oa, sysindexes si
where oa.ObjectID = si.id 
  and oa.IndexID = si.indid
 -- and UsedCount = 0 
 -- and OptSelectCount = 0 
  and ObjectID > 99 
  and IndexID >= 1 and IndexID != 255 
  and DBID = db_id() -- remove this to run server-wide
  and object_name(ObjectID, DBID) = 'Mailbox'
--  and object_name(ObjectID, DBID) = 'ASM'
order by 1,2

--=============================================
-- the end of unusd index 
--==============================================