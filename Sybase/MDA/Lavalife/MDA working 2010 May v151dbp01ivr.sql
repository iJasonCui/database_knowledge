set rowcount 0
SELECT 
--*
--DBName , 
SRVName,
count(*)--,
--, avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
--min(StartTime)
FROM "mda_user"."proc_stats"
--WHERE 
--SRVName = 'v151dbp01ivr'
--SRVName = 'v151db20'
--and ProcName like '%Greet%'
--and ProcName like 'inv%'
--AND ProcName = 'gsp_newMsgnum'
--and ProcName = 'gsp_cfgGetLocationSpc'
 -- and ProcName = 'gsp_getSavedMessages'
--and ProcName = 'gsp_getNewMessages'
--and ProcName = 'gsp_velocityCheck'
--and ProcName like '%Messages%'
-- and ProcName like '%Msg%'
--  AND DBName != 'SMSGateway'
  --AND DBName != 'invDB'
 -- and DBName = 'nycLL'
 -- AND StartTime >= 'apr 30 2010'
--  AND StartTime <  'Jan 20 2010'
 -- AND ElapsedTime > 200
--ORDER BY StartTime asc --desc
--order by ElapsedTime desc
--order by logicalReads desc
--group by DBName
group by SRVName
;