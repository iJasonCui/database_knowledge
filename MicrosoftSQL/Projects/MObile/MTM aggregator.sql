14. MTM project missing data trouble shooting

[stored procedure] are residing on archive database instead of evolve database

select * from succor.audit.tObjectConfigTable where objectKey in (246)
--246	acumen	fact	pIAggregatorMTM	evolve	mobile	1	KRYPTON\bwiese                	

select * from acumen.fact.tAggregator 
--where dateKey = 'sep 25 2011' 
where loadTableKey = 377512
313911

select * from acumen.fact.tMTM
where dateKey = 'sep 25 2011' 

13.1 Pick where to start, in this case I'll start with the Fact table - Identify objectkey

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'Fact Table')

--39	tSaleMessage	Sales and Messages	Fact Table	Mobile
--106	tWapImpression	Wap Impressions	Fact Table	Mobile
--189	tAggregator	tAggregatorAtlas	Fact Table	Mobile
--246	tAggregator	AggregatorMTM	Fact Table	Mobile
--249	tAggregator	AggregatorMblox	Fact Table	Mobile
--277	tMBloxSummary	MBloxSummary 	Fact Table	Mobile

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'Archive Table')

--100	Dump_MTMDaily	Dump MTM Daily	Archive Table	Mobile

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'File')


13.2 Check the tLoadTable for the above objectkey for the last couple of days

select * from succor.audit.tLoadTable
where 
objectKey in (246) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tLoadArchive
where 
objectKey in (100) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

--update succor.audit.tLoadArchive set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null where loadArchiveKey in (345532)

select * from succor.audit.tLoadFile 
where loadFileKey = 313911
where 
objectKey in (100) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey



13.3 THe above query tells me that the archive failed, so now I query the tLoadArchive table

select * from succor.audit.tLoadArchive
where 
--loadarchiveKey in (345382, 345740)
loadarchiveKey in (354483)

select * from succor.audit.tLoadFile
where 
loadFileKey in (313657, 313911)


13.4 The above query tells me that the # of attempts were max'd out, so update tLoadArchive table this will add it back to the queue

--update succor.audit.tLoadArchive set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null where loadArchiveKey in (345382, 345740)
update succor.audit.tLoadArchive set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null where loadArchiveKey in (345532)
--update succor.audit.tLoadTable set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null where loadTableKey in (377512)

--exec archive.mobile.MTMDaily_Update @FromDate datetime = null, @ToDate datetime =null
exec archive.mobile.MTMDaily_Update '20110925', '20110926'
--================================================
