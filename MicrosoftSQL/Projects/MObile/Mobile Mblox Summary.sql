14. Mobile mBlox summary report

http://reports.mblox.com


14.1 After logging in, he would have clicked on “PSMS MT Breakdown”, 
14.2 then selected the LavalifeUS account, 
14.3 entered in start and end dates for each day (dd/mm/yyyy), 
14.4 de-selected all options except “Full Breakdown”.

14.5 Barry's Macro at FSCorp

U:\Mobile\++CLEANUP++\+BARRY+\Mobile Docs '2009\mBlox Reports\GetWebStuff-AS4 V19

--Mobile
SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'Fact Table')
--277	tMBloxSummary	MBloxSummary 	Fact Table	Mobile

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'Archive Table')
--276	mBloxSummary	mBloxSummary	Archive Table	Mobile

SELECT    * --objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
where     objectKey = 277

select * from succor.audit.tLoadTable
where objectKey in (277) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tLoadArchive
where objectKey in (276) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tLoadFile where loadFileKey in (
select loadFileKey from succor.audit.tLoadArchive
where objectKey in (276) and dateKey >= dateadd(day,-15,convert(char(11),getdate())) )

--update succor.audit.tLoadFile 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 0, attempts =0, 
    finishedDateTime = null, startDateTime = null
where rowCountLoaded = 0 and rowCountRaw = -1 and loadFileKey in (
select loadFileKey from succor.audit.tLoadArchive
where objectKey in (276) and dateKey >= dateadd(day,-40,convert(char(11),getdate())) )

--update succor.audit.tLoadFile 
set rowCountRaw = 9009, rowCountLoaded = 9009, statusKey = 2, attempts =1, 
    finishedDateTime = 'jun 3 2011', startDateTime = 'jun 3 2011'
where loadFileKey = 284445 

select * from acumen.fact.tMbloxSummary where loadTableKey = 335061

select * from archive.mobile.mBloxSummary where loadArchiveKey = 348964 
and messageDate >= '2011-09-23'
order by messageDate

