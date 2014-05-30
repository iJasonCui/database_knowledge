set rowcount 0
SELECT --*
DBName,ProcName, count(*) as cn, avg(ElapsedTime), max(ElapsedTime), min(ElapsedTime), min(StartTime), max(StartTime)
FROM "mda_user"."proc_stats"
WHERE SRVName = 'w151dbp03'
  AND ProcName in (
'wsp_getNewSmileByTargetUserId',
'wsp_getNewViewedByTargetUserId',
'wsp_cntTotalViewedMe',
'wsp_getNewPassByTargetUserId',
'wsp_getOnlineStats',
'wsp_getOnlineHotlistByUserId',
'wsp_getOnlineSmileSentByUserId',
'wsp_getOnlineSmileRecvByUserId',
'wsp_getOnlineViewedMeByUserId',
'wsp_getSmile4Newsfeed',
'wsp_getViewedMe4Newsfeed',
'wsp_getPass4Newsfeed',
'wsp_getHotlist4Newsfeed'
)
--and ProcName = 'gsp_cfgGetLocationSpc'
  --AND DBName != 'SMSGateway'
  --AND DBName = 'Profile_ai'
  AND StartTime >= 'apr 22 2010 8:30'
  AND StartTime <  'apr 22 2010 22:30'
 --AND ElapsedTime > 200
--ORDER BY StartTime desc
--order by ElapsedTime desc
--order by LogicalReads desc
--group by DBName
group by DBName,ProcName
order by DBName, ProcName
;