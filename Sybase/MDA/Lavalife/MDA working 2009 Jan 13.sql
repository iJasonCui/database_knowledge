set rowcount 0
select * --count(*) 
from mda_user.proc_stats 
where SRVName = 'v151dbp01ivr' 
--SRVName = 'sipdb-11' and 
and DBID !=63  and 
dateCreated > 'jan 11 2009' and dateCreated < 'jan 12 2009'  
--and DBName = 'vanLL' 
--and DBName = 'nycLL' 
--and ProcName like 'inv_expOrphan%'
--and ProcName like 'inv_%'
--and ProcName like '%nycLL'
and ProcName = 'gsp_DAVelocityCheck'
--and ProcName = 'gsp_getCellFishCalls'
--and ProcName = 'gsp_saveSearch'
--and ProcName = 'gsp_getTrackDefaultRadius'
--order by LogicalReads desc;
and ElapsedTime > 1000
and LogicalReads > 10000
order by ElapsedTime desc
--order by StartTime desc
;

