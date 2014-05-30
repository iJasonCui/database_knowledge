--set rowcount 100
SELECT *
--DBName , 
--ProcName, count(*), avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'v151dbp03ivr' 
--SRVName = 'v151db20'
--AND ProcName = 'gsp_newMsgnum'
--and ProcName = 'gsp_getConcentricSessions'
 -- and ProcName = 'gsp_getSavedMessages'
--and ProcName = 'gsp_getNewMessages'
and ProcName = 'gsp_getTrialSessionsApproved'
--and ProcName like '%Messages%'
-- and ProcName like '%Msg%'
  AND DBName = 'nycNE'
  --AND DBName != 'configDB'
--and DBName in ('mtlNEF', 'sfoNE', 'torNE')
  AND StartTime >= '2010-07-28 '
  AND StartTime <  '2010-07-29'
 -- AND EndTime >= '2010-05-06 13:56'
  --AND EndTime <  '2010-05-06 14:01'
  AND ElapsedTime > 200
--ORDER BY StartTime desc
order by ElapsedTime desc
--order by logicalReads desc
--group by ProcName
;

