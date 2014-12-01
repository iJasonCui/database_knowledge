--SNAP SHOT
SELECT p.hostname, d.name as db_name, l.name as login_name, count(*)
  FROM master..sysprocesses p, master..syslogins l, master..sysdatabases d
 WHERE p.dbid = d.dbid and p.suid = l.suid
 GROUP BY p.dbid, p.suid, p.hostname, d.name, l.name
 ORDER BY p.hostname, d.name, l.name

--sp_monitorconfig "number of locks"
--sp_monitorconfig "number of user connections"

set system_view cluster
go

select object_name(ProcedureID, DBID) as Proc_name, CpuTime, StartTime,db_name(DBID), p.hostname, m.*
from master..monProcessStatement m, master..sysprocesses p 
where SPID != @@spid
   and SPID = p.spid
order by CpuTime desc

select p.hostname, m.*  
 from master..monProcessObject m, master..sysprocesses p 
where SPID != @@spid
   and m.SPID = p.spid
   order by m.LogicalReads desc
   
   
set system_view cluster
go

select sp.ipaddr, 
u.name,
s.DBName,
s.SPID,
s.KPID, 
sp.program_name,
object_name(s.ProcedureID, s.DBID) as "ObjectName",
datediff(ss, s.StartTime, getdate()) as "ElapsedTime",
s.StartTime,
getdate(),
s.CpuTime, 
sp.instanceid,
s.PhysicalReads,
s.LogicalReads, 
s.PacketsSent, 
s.PacketsReceived
from master..sysprocesses sp
left join master..monProcessStatement s on sp.spid = s.SPID
left join master..syslogins u on u.suid = sp.suid
where s.SPID != @@spid
and program_name not like "DeadLock_Collector"


--select * from DBA_Admin..monProcessStatement a where a.RunDate >= "Jun 18 2014 11:00"
