set rowcount 100
SELECT *
--DBName , 
--ProcName, count(*), avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'v151dbp03ivr' 
--SRVName = 'v151db20'
AND ProcName = 'gsp_newSessid'
--  AND DBName = 'nycNE'
--and DBName in ('mtlNEF', 'sfoNE', 'torNE')
  AND StartTime >= '2010-08-09 '
  AND StartTime <  '2010-08-10'
 -- AND EndTime >= '2010-05-06 13:56'
  --AND EndTime <  '2010-05-06 14:01'
 -- AND ElapsedTime > 200
ORDER BY StartTime desc
--order by ElapsedTime desc
--order by logicalReads desc
--group by ProcName
;

