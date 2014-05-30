set rowcount 100
SELECT *
--DBName , 
--count(*), avg(ElapsedTime), max(ElapsedTime) 
--max(dateCreated)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'w151dbp04'
--SRVName = 'v151db20'
AND ProcName = 'wsp_getPendingListPic'
--and ProcName = 'gsp_cfgGetLocationSpc'
--  AND DBName != 'SMSGateway'
--  AND DBName != 'configDB'
and DBName = 'Admin'
  AND StartTime >= 'sep 22 2009 '
--  AND StartTime <  'May 8 2009'
 AND ElapsedTime > 200
--ORDER BY StartTime desc
--order by ElapsedTime desc
order by logicalReads desc
--group by DBName
;
