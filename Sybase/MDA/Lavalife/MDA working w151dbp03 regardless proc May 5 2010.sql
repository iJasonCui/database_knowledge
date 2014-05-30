set rowcount 100
SELECT *
--DBName,ProcName, count(*) as cn, avg(ElapsedTime), max(ElapsedTime), min(ElapsedTime), min(StartTime), max(StartTime)
FROM "mda_user"."proc_stats"
WHERE SRVName = 'w151dbp03'
--and ProcName = 'gsp_cfgGetLocationSpc'
  --AND DBName != 'SMSGateway'
  --AND DBName = 'Profile_ai'
  AND StartTime >= 'May 6 2010 9:00'
  AND StartTime <  'May 6 2010 10:00'
AND ElapsedTime > 200
--ORDER BY StartTime desc
order by ElapsedTime desc
--order by LogicalReads desc
--group by DBName
--group by DBName,ProcName
--order by DBName, ProcName
;
