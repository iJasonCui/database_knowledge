--set rowcount 100
select count(*) 
from mda_user.proc_stats 
where SRVName = 'w151dbp02' 
--and dateCreated > 'feb 25 2009' and dateCreated < 'feb 26 2009'  
--and DBName = 'vanLL' 
--and DBName = 'nycLL' 
--and ProcName like 'inv_expOrphan%'
--and ProcName like 'inv_%'
--and ProcName like '%nycLL'
--and ProcName = 'gsp_DAVelocityCheck'
--and ProcName = 'gsp_getCellFishCalls'
--and ProcName = 'gsp_saveSearch'
--and ProcName = 'gsp_getTrackDefaultRadius'
--order by LogicalReads desc;
--and ElapsedTime > 200
--and LogicalReads > 10000
--order by ElapsedTime desc
--order by StartTime desc
;

