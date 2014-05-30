--fact.tWebActiveMember
--fact.vWebNewUnique

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Fact Table')

--363	tWebNewUnique	Web - New Uniques	Fact Table	WEB
--365	tWebActiveMember	Web - Active Members	Fact Table	WEB

--load table 
select * from succor.audit.tObjectConfigTable where objectKey in (363, 365)
--365 evolve.web.pIWebActiveMember
--363 evolve.web.pIWebNewUnique

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Archive Table')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'File')

--load archive
select * from succor.audit.tLoadArchive 
where objectKey in (70, 71) and 
dateKey >= dateadd(day,-60,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tObjectConfigArchive where objectKey in (63, 70, 71)

--select * from [acumen].[fact].[tIvrSales] 

select * from succor.audit.tLoadArchive where loadArchiveKey = 303639  --Activity
select * from succor.audit.tLoadArchive where loadArchiveKey = 303640  --ActivityOther

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 0, attempts =0, 
    finishedDateTime = null, startDateTime = null where loadArchiveKey = 303639

--update succor.audit.tLoadArchive 
set rowCountRaw = 7341, rowCountLoaded = 7341, statusKey = 6, attempts =1, 
    minDateTime = '2011-05-31 00:00:16', maxDateTime = '2011-05-31 23:59:53',
    finishedDateTime = 'jul 21 2011 2:35pm', startDateTime = 'jul 21 2011 2:20pm' where loadArchiveKey = 303639

select min(dateModified), max(dateModified), count(*)  FROM [archive].[pos].[Activity] where loadArchiveKey = 303639
--delete FROM [archive].[pos].[Activity] where loadArchiveKey = 303639
select *  FROM [archive].[pos].[ActivityOther] where loadArchiveKey = 303640

exec succor.etl.pSLoadArchive_WaitingToLoad 70
exec succor.etl.pSLoadArchive32Bit_WaitingToLoad 70

--update succor.audit.tLoadArchive 
set statusKey = 0, attempts = 0, finishedDateTime = null where loadArchiveKey = 303639

--load table 
select * from succor.audit.tObjectConfigTable where objectKey in (80,75, 10)

select * from succor.audit.tLoadTable
where objectKey in (80) and 
dateKey >= dateadd(day,-30,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tLoadTable
where objectKey in (75) and 
dateKey >= dateadd(day,-10,convert(char(11),getdate()))
order by objectKey,dateKey

exec succor.etl.pSLoadTable_WaitingToLoad 80

--table
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 334506
--delete from [acumen].[fact].[tIvrSales] where loadTableKey = 334506

select * from succor.audit.tLoadTable where loadTableKey = 334506
