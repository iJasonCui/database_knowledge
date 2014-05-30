select DBName, ProcName, count(*) as ExecCount, 
       min(ElapsedTime) as minExeTime, max(ElapsedTime) as maxExeTime, convert(int, avg(ElapsedTime)) as avgExeTime   
into #MostExecuted
from mda_user.proc_stats
where SRVName      = 'w151dbp04'
  and dateCreated >= 'Apr 11 2010'
  and dateCreated < 'Apr 12 2010'
group by DBName, ProcName 

select DBName, ProcName, count(*) as ExecCount, min(dateCreated) as min_startTime, max(dateCreated) as max_startMax
into #MostExecutedPrevious
from mda_user.proc_stats
where SRVName      = 'w151dbp04'
  and dateCreated >= 'Apr 4 2010'
  and dateCreated <  'Apr 5 2010'
group by DBName, ProcName

select t1.ProcName, t1.DBName, 
       t1.ExecCount as ExecCount1, 
       t2.ExecCount as ExecCount2, 
       t1.ExecCount - t2.ExecCount as CountDiff, 
       (abs(CountDiff) * 100 / t1.ExecCount) as CountDiffPercent
  into #ProcInTodayInYesterday
  from #MostExecuted  t1, #MostExecutedPrevious t2
 where t1.ProcName = t2.ProcName
   and t1.DBName = t2.DBName

select ProcName, DBName, ExecCount1 , ExecCount2 as ExecCountPrevious, CountDiff, CountDiffPercent
from #ProcInTodayInYesterday
where CountDiffPercent >= 20  
order by CountDiffPercent desc

select top 20 ProcName, DBName, ExecCount1 , ExecCount2 as ExecCountPrevious, CountDiff, CountDiffPercent
from #ProcInTodayInYesterday
order by CountDiffPercent desc
