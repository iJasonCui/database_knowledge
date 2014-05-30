--set rowcount 100
SELECT 
--*
--DBName , 
--SRVName,
count(*)--,
--, avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
--min(StartTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'w151dbr02'
--SRVName = 'v151db20'
--and ProcName like '%Greet%'
--and ProcName like 'inv%'
AND ProcName = 'wsp_getPendingListBg'
--and ProcName = 'gsp_cfgGetLocationSpc'
 -- and ProcName = 'gsp_getSavedMessages'
--and ProcName = 'gsp_getNewMessages'
--and ProcName = 'gsp_velocityCheck'
--and ProcName like '%Messages%'
-- and ProcName like '%Msg%'
--  AND DBName != 'SMSGateway'
  --AND DBName = 'Admin'
  --and DBName = 'Profile_ad'
  AND StartTime >= 'Mar 9  2010'
  AND StartTime <  'mar 10 2010'
 --AND ElapsedTime > 10
--ORDER BY StartTime desc
--order by ElapsedTime desc
--order by logicalReads desc
--group by DBName
--group by SRVName
;
