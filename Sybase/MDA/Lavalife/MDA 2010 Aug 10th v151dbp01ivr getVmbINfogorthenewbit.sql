set rowcount 100
SELECT *
--DBName , 
--ProcName, count(*), avg(ElapsedTime), max(ElapsedTime), MIN(ElapsedTime)
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'v151dbp01ivr' 
--SRVName = 'v151db20'
--AND ProcName = 'gsp_newSessid'
AND ProcName in ('gsp_getVmbInfoForTheNewBit', 'gsp_getSentMsgsForTheNewBit')
--AND ProcName like '%QC%'
--  AND DBName = 'atlLL'
--and DBName in ('mtlNEF', 'sfoNE', 'torNE')
  AND StartTime >= '2010-08-12 19:10'
--  AND StartTime <  '2010-08-13'
 -- AND EndTime >= '2010-05-06 13:56'
  --AND EndTime <  '2010-05-06 14:01'
--  AND ElapsedTime > 100
ORDER BY StartTime desc
--order by ElapsedTime desc
--order by logicalReads desc
--group by ProcName
;

