--set rowcount 100
SELECT 
*
--DBName , 
--ProcName, count(*), avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'c151dbp02pgs' 
--SRVName = 'v151db20'
--AND ProcName = 'gsp_newMsgnum'
--and ProcName = 'gsp_getConcentricSessions'
 -- and ProcName = 'gsp_getSavedMessages'
--and ProcName = 'gsp_getNewMessages'
and ProcName = 'gsp_getCommunicationsHistory'
--and ProcName like '%Messages%'
-- and ProcName like '%Msg%'
  AND DBName = 'IVRMobile'
  --AND DBName != 'configDB'
--and DBName in ('mtlNEF', 'sfoNE', 'torNE')
  AND StartTime >= '2010-06-02'
  AND StartTime <  '2010-06-04'
 -- AND EndTime >= '2010-05-06 13:56'
  --AND EndTime <  '2010-05-06 14:01'
  --AND ElapsedTime > 200
ORDER BY StartTime desc
--order by ElapsedTime desc
--order by logicalReads desc
--group by ProcName
;

