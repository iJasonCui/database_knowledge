14. wap impression project missing data trouble shooting

[stored procedure] are residing on archive database instead of evolve database

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

13.2 Check the tLoadTable for the above objectkey for the last couple of days

select * from succor.audit.tLoadTable
where 
objectKey in (106) and 
dateKey >= dateadd(day,-30,convert(char(11),getdate())) and rowCountLoaded = 0
order by objectKey,dateKey
--16 rows 

13.3 THe above query tells me that the archive failed, so now I query the tLoadArchive table

select * from succor.audit.tLoadArchive
where 
loadarchiveKey in (
select loadarchiveKey from succor.audit.tLoadTable
where 
objectKey in (106) and 
dateKey >= dateadd(day,-30,convert(char(11),getdate())) and rowCountLoaded = 0
)

select * from succor.audit.tLoadFile
where 
loadFileKey in (313405, 313406)


13.4 The above query tells me that the # of attempts were max'd out, so update tLoadArchive table this will add it back to the queue

--update succor.audit.tLoadArchive set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null where loadArchiveKey in (345175, 345176)

--update succor.audit.tLoadArchive set statusKey = 2,attempts = 0,startDateTime=null,finishedDateTime=null 
where loadArchiveKey in 
(select loadarchiveKey from succor.audit.tLoadTable
where 
objectKey in (106) and 
dateKey >= dateadd(day,-30,convert(char(11),getdate())) and rowCountLoaded = 0)
--================================================
