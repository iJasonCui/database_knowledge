select top 50 DBName, ProcName, count(*) as ExecCount, 
       min(ElapsedTime) as minExeTime, max(ElapsedTime) as maxExeTime, convert(int, avg(ElapsedTime)) as avgExeTime   
from mda_user.proc_stats
where SRVName      = 'w151dbp03'
  and dateCreated >= 'may 6 2010'
  and dateCreated < 'may 7 2010'
group by DBName, ProcName 
order by ExecCount desc
;

