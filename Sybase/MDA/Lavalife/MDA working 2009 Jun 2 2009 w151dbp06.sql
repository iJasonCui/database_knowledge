set rowcount 0
SELECT
--DBName,ProcName, count(*) as cn --, avg(ElapsedTime), max(ElapsedTime)  --performance
DBName, 'INSERT mda_db..mdaProcsUSI (name) VALUES ("' + ProcName + '")' 
FROM 
"mda_user"."proc_stats"
--"mda_user"."proc_stats_w151dbp02"
WHERE 
SRVName ='w151dbp02'
  --AND ProcName in ('wsp_newJumpUser')
--  AND 
and DBName = 'USI'
  --AND DBName in ( 'SuccessStory', 'Jump', 'Content', 'ContentJava', 'SurveyPoll', 'SuccessStory', 'Tracking' )
 -- AND StartTime >= 'Jan 1 2011'
--  AND StartTime <  'May 8 2009'
-- AND ElapsedTime > 200
--ORDER BY StartTime desc
--order by ElapsedTime desc
--order by LogicalReads desc
--group by DBName
group by DBName,ProcName
--order by DBName, cn desc
;