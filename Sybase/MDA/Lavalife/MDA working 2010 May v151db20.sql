set rowcount 0
SELECT 
--*
--DBName , 
--SRVName,
--count(*)--,
ProcName, count(*), avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
--min(StartTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'v151db20'
--and ProcName like '%Greet%'
--and ProcName like 'inv%'
--AND ProcName = 'gsp_getTrialSessionsApproved'
--AND ProcName = 'gsp_newMsgnum'
--and ProcName = 'gsp_cfgGetLocationSpc'
 -- and ProcName = 'gsp_getSavedMessages'
--and ProcName = 'gsp_getNewMessages'
--and ProcName = 'gsp_velocityCheck'
and ProcName  in ('gsp_getAdsConcentric2', 'gsp_getEthnicAdsConcentric2')
--and ProcName like '%Messages%'
-- and ProcName like '%Msg%'
--  AND DBName != 'SMSGateway'
  --AND DBName != 'configDB'
--  and DBName = 'nycNE'
  AND StartTime >= 'jun 1 2010 '
--  AND StartTime <  'Jan 20 2010'
--AND ElapsedTime > 200
--ORDER BY StartTime 
--order by ElapsedTime desc
--order by logicalReads desc
--group by DBName
--group by SRVName
group by ProcName
;
