SELECT 
*
--DBName , 
--count(*), avg(ElapsedTime), max(ElapsedTime) 
FROM "mda_user"."proc_stats"
WHERE 
SRVName = 'v151dbp01ivr'
--SRVName = 'v151db20'
--AND ProcName = 'gsp_newMsgnum'
--AND ProcName = 'gsp_newIVRMailbox'
--and ProcName = 'gsp_cfgGetLocationSpc'
and ProcName = 'inv_expAd_torLL'
  AND DBName != 'SMSGateway'
  AND DBName != 'configDB'
  and DBName in ('torLL', 'invDB' )
--and DBName in ('nycNE' )
  AND StartTime >= 'jul 24 2009 19:00 '
 --AND StartTime <  'jul 24 2009 6:00'
--AND ElapsedTime > 200
--ORDER BY StartTime desc
order by  ElapsedTime desc
--order by logicalReads desc
--order by PhysicalReads desc
--group by DBName
;
