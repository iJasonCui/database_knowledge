


select * from RepLatencyLog r where r.replicateDBId >= 400 and r.dateCreatedPrimary > "mar 1 2008"

select * from v_RepLatencyLog30 a where a.replicateDBName = "Profile_ad" and a.dateCreatedPrimary < "may 4 2010"

select * from v_RepLatencyLog v where 
--replicateDBName = "Profile_ai" and 
replicateSRVName = "w151dbr01" and 
v.dateCreatedPrimary >= "feb 1 2010 11:00"

--============================
select * from repStats..UserDefinedRepLatency a where dataCreated >= "mar 1 2008" and dataCreated <= "mar 8 2008" and serverId >= 400

select * from repStats..UserDefinedRepLatency a where dataCreated >= "oct 11 2006" and dataCreated <= "oct 17 2006" and a.latencyInSec > 30 and serverId = 21

select * from repStats..UserDefinedRepLatency a where dataCreated >= "oct 04 2006" and dataCreated <= "oct 10 2006" and a.latencyInSec > 30 and serverId = 21

select * from repStats..UserDefinedRepLatency a where dataCreated >= "sep 5 2006" and dataCreated <= "sep 6 2006" --and a.latencyInSec > 100

select * from repStats..UserDefinedRepLatency a where dataCreated >= "jul 10 2006" and dataCreated <= "jul 11 2006" --and a.latencyInSec > 100

select dateadd(ss, 20, "jan 1 1970")
--========================= production
set rowcount 0
select * from repStats..RepLatency 
where dateCreated > "oct 17 2006 " 
--and dBServer like "w151db%"
and dBName like "Profile_ad"
order by dateCreated desc

set rowcount 0
select * from repStats..RepLatency 
where dateCreated > "oct 22 2008 " 
and dBServer = "webdb21p"
order by dateCreated desc

set rowcount 0
select * from repStats..RepLatency 
where dateCreated > "oct 16 2006 11:00am" 
and dBName like "Session%"
--  and latencyInSec > -20
and dBServer = "webdb27p"

set rowcount 0
select * from repStats..RepLatency 
where dateCreated > "sep 22 2005 7:00am" and dBName in ( 
"USI" ,
"Jump",
"Session",
"Member",
"Msg_ad",
"Mag_ar",
"Msg_ai"
  )
 
set rowcount 0
select * from repStats..RepLatency 
--where latencyInSec > 20 
--where dBName = "Session" and latencyInSec > 1
where primaryDBID = 153

select PrimaryDBID = origin, 
       LatencyInSec = datediff(ss, origin_time, dest_commit_time),
       LastXactOriginTime = convert(varchar(40), origin_time, 109),
       LastXactDestCommitTime = convert(varchar(40), dest_commit_time, 109)
from   Profile_ad_view..rs_lastcommit       
where origin > 0 
 
select PrimaryDBID = origin, 
       LatencyInSec = datediff(ss, origin_time, dest_commit_time),
       LastXactOriginTime = convert(varchar(40), origin_time, 109),
       LastXactDestCommitTime = convert(varchar(40), dest_commit_time, 109)
from   Session..rs_lastcommit       
where origin > 0 


--================= testing
set rowcount 0
select dBServer,	dBName,	primaryDBID,	
case when dBServer = "opsdb2p" then (latencyInSec - 180) 
     when dBServer = "asedb0d" then (latencyInSec + 180)
     when dBServer = "msadb0d" then latencyInSec - 30
end     
as   latencyInSecond,
case when dBServer = "opsdb2p" then dateadd(ss, +180, lastXactOriginTime)
     when dBServer = "asedb0d" then dateadd(ss, -180, lastXactOriginTime)
     when dBServer = "msadb0d" then dateadd(ss, +30, lastXactOriginTime)
     
end
as   lastXactStartTime, 
lastXactDestCommitTime,	
dateCreated
from repStats..RepLatencyTest

select PrimaryDBID = origin, 
       LatencyInSec = datediff(ss, origin_time, dest_commit_time),
       LastXactOriginTime = convert(varchar(40), origin_time, 109),
       LastXactDestCommitTime = convert(varchar(40), dest_commit_time, 109)
from   SessionTest..rs_lastcommit       
where origin > 0

select getdate()




PrimaryDBID	LatencyInSec	LastXactOriginTime	LastXactDestCommitTime
223	1035	May 25 2005  7:38:12:603AM	May 25 2005  7:55:27:983AM
PrimaryDBID	LatencyInSec	LastXactOriginTime	LastXactDestCommitTime
223	1048	May 25 2005  7:38:12:603AM	May 25 2005  7:55:41:380AM

 


select PrimaryDBID = origin, 
       LatencyInSec = datediff(ss, origin_time, dest_commit_time),
       LastXactOriginTime = convert(varchar(40), origin_time, 109),
       LastXactDestCommitTime = convert(varchar(40), dest_commit_time, 109)
from   Member..rs_lastcommit       
where origin > 0

select PrimaryDBID = origin, 
       LatencyInSec = datediff(ss, origin_time, dest_commit_time),
       LastXactOriginTime = convert(varchar(40), origin_time, 109),
       LastXactDestCommitTime = convert(varchar(40), dest_commit_time, 109)
from   Accounting..rs_lastcommit       
where origin > 0









