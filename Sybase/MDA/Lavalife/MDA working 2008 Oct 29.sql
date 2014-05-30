
--drop table invDB..monSysStatement
select @@serverName as serverName, getdate() as dateCreated, * into invDB..monSysStatement from master..monSysStatement

--select @@serverName as serverName, getdate() as dateCreated, * into tmpDB2..monSysStatement from master..monSysStatement

select 
--insert into invDB..monSysStatement
select @@serverName as serverName, getdate() as dateCreated, *  from master..monSysStatement

--insert into tmpDB2..monSysStatement
--select @@serverName as serverName, getdate() as dateCreated, *  from master..monSysStatement


select serverName, dateCreated, KPID, BatchID, LineNumber, LogicalReads, EndTime -- Elapsed = datediff(ms,StartTime, EndTime) 
from invDB..monSysStatement 
--where LogicalReads > 100
order by 7 desc



select @@serverName as serverName, getdate() as dateCreated, * into #monSysStatement from master..monSysStatement


select * from  #monSysStatement

--========================================



    select ProcName = isnull(object_name(ProcedureID, DBID), "UNKNOWN"),
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
        StartTime = min(StartTime),
        EndTime = max(EndTime),
        ElapsedTime = datediff(ms, min(StartTime), max(EndTime)),
         ElapsedTime1 = sum(datediff(ms, StartTime, EndTime)),
--        ElapsedTime=0,
        dateCreated = getdate(),
        NumExecs = 1
--from master..monSysStatement
from mda_db..jason1
where  ProcedureID != 0 
   and DBID >= 4 and DBID < 30000
--   and    SPID = 357 and   KPID = 958137095 and DBID = 5 AND ProcedureID =1645964940
group by SPID, DBID, ProcedureID, BatchID 
--having ProcedureID != 0    and DBID >= 4 and DBID < 30000



select * into mda_db..jason1 from master..monSysStatement

set rowcount 0
select ProcName = isnull(object_name(ProcedureID, DBID), "UNKNOWN"),
        DBName = isnull(db_name(DBID), "UNKNOWN"), * from mda_db..jason1
where         SPID = 357 and      KPID = 958137095 and DBID = 5 AND ProcedureID =1645964940


set rowcount 10
select ProcName = isnull(object_name(ProcedureID, DBID), "UNKNOWN"),
        DBName = isnull(db_name(DBID), "UNKNOWN"), * from mda_db..jason1 b where b.LogicalReads > 1000
       
        
     

        ProcName     DBName SPID   KPID   DBID   ProcedureID   PlanID BatchID       ContextID     LineNumber       CpuTime       WaitTime      MemUsageKB    PhysicalReads LogicalReads  PagesModified PacketsSent       PacketsReceived      NetworkPacketSize    PlansAltered  StartTime     EndTime
gsp_getMsgCounts     nycNE  105    1027211704    5      1576392685    257145 2      1      0      0      0       8      0      0      0      0      0      512    0      30/10/2008 2:40:41.983 AM  30/10/2008 2:40:41.983 AM
                                                                                                                                                

        
select  * from mda_db..jason1


--===================================

set rowcount 0
select * from mda_db..proc_stats a  where a.ElapsedTime > 200 order by a.ElapsedTime desc

select convert(char(12), a.EndTime, 109), count(*) from mda_db..proc_stats a  
where a.EndTime >= "nov 1 2008"  -- and a.ElapsedTime < 60000
group by convert(char(12), a.EndTime, 109)

Nov  1 2008 	3245767
Nov  2 2008 	3524883
Nov  3 2008 	1792794
	
select convert(char(12), a.EndTime, 109), count(*) from mda_db..proc_stats a  
where a.ElapsedTime > 200 and a.EndTime >= "nov 1 2008" and a.DBID != 63 -- and a.ElapsedTime < 60000
group by convert(char(12), a.EndTime, 109)

Nov  1 2008 	6411
Nov  2 2008 	17592
Nov  3 2008 	15297

--without SMSGateway	
Nov  1 2008 	903
Nov  2 2008 	12355
Nov  3 2008 	12715
	
select convert(char(12), a.EndTime, 109), count(*) from mda_db..proc_stats a  
where a.ElapsedTime > 1000 and a.EndTime >= "nov 1 2008" and a.DBID != 63  -- and a.ElapsedTime < 60000
group by convert(char(12), a.EndTime, 109)

Nov  1 2008 	5713
Nov  2 2008 	5582
Nov  3 2008 	2878

--without SMSGateway	
Nov  1 2008 	243
Nov  2 2008 	366
Nov  3 2008 	302
	
--v151dbp01ivr 	
Oct 31 2008	9271
Oct 30 2008	368567
	

select min(a.dateCreated) from mda_db..proc_stats a  
select max(a.dateCreated) from mda_db..proc_stats a  

set rowcount 20
select * from mda_db..proc_stats a where a.dateCreated >= "oct 30 2008 " order by a.ElapsedTime desc
--a.dateCreated


set rowcount 20
select * from mda_db..proc_stats a where a.LogicalReads > 100000 and a.EndTime > "oct 31 2008"
 order by a.LogicalReads desc
 
 select * from mda_db..proc_stats a where a.ProcName = "inv_listMailbox_nycNE"
 
  select * from mda_db..proc_stats a where a.ProcName = "inv_listMailbox_nycLL"