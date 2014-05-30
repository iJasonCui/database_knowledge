set rowcount 0
SELECT --*
DBName,ProcName, count(*) as cn, avg(ElapsedTime), max(ElapsedTime), max(LogicalReads)
FROM "mda_user"."proc_stats"
WHERE SRVName = 'w151dbp04'
  AND ProcName in (
'wsp_getActOL4NewsfeedUserId',
'wsp_getActPict4NewsfeedUserId',
'wsp_getActAd4NewsfeedUserId'
)
  --AND DBName = 'Jump'
  AND StartTime >= 'apr 14 2010 11:00'
  AND StartTime <  'apr 14 2010 14:00'
--AND ElapsedTime > 200
--ORDER BY StartTime desc
--order by ElapsedTime desc
--order by LogicalReads desc
--group by DBName
group by DBName,ProcName
--order by DBName, cn desc
;
