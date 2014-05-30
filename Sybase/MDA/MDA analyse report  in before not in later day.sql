print '-----------------------------------------------------------------------'
print 'Top 20 Been Executed (popular) Stored Procedures               '
print '-----------------------------------------------------------------------'
print '  '

select DBName, ProcName, count(*) as ExecCount, 
       min(ElapsedTime) as minExeTime, max(ElapsedTime) as maxExeTime, convert(int, avg(ElapsedTime)) as avgExeTime   
into #MostExecuted
from mda_user.proc_stats
where SRVName      = 'w151dbp04'
  and dateCreated >= 'Apr 11 2010'
  and dateCreated < 'Apr 12 2010'
group by DBName, ProcName 

print '-----------------------------------------------------------------------'
print 'Stored Procedures were executed in the previous day, not in reporting period '
print '-----------------------------------------------------------------------'
print '  '

select DBName, ProcName, count(*) as ExecCount, min(dateCreated) as min_startTime, max(dateCreated) as max_startMax
into #MostExecutedPrevious
from mda_user.proc_stats
where SRVName      = 'w151dbp04'
  and dateCreated >= 'Apr 4 2010'
  and dateCreated <  'Apr 5 2010'
group by DBName, ProcName

select t1.ProcName, t1.DBName, t1.ExecCount as ExecCount1, t2.ExecCount as ExecCount2  
into   #ProcInYesterdayNotToday
from #MostExecutedPrevious t1, #MostExecuted t2
where t1.ProcName *= t2.ProcName 
  and t1.DBName *= t2.DBName  

select ProcName, DBName, ExecCount1 
from  #ProcInYesterdayNotToday
where ExecCount2 is null
;
