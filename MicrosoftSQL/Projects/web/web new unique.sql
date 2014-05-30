--fact.tWebActiveMember

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Fact Table')

--365	tWebActiveMember	Web - Active Members	Fact Table	WEB
--242	tWebPurchase	tWebPurchase	Fact Table	WEB
--363	tWebNewUnique	Web - New Uniques	Fact Table	WEB

select * from succor.audit.tLoadArchive where loadArchiveKey = 383413
select * from succor.audit.tLoadArchive where loadArchiveKey =   383415

select * from succor.audit.tLoadTable where loadArchiveKey = 378832  
select * from succor.audit.tLoadTable where loadArchiveKey = 379190  

DECLARE @loadTableKey int, @results int
SELECT @loadTableKey = 
--416076 --ebNewUnique
415941 --sales
EXEC [evolve].[web].[pIWebPurchase] @loadTableKey , @results output
EXEC [evolve].[web].[pIWebNewUnique] @loadTableKey , @results output

--load table 
select * from succor.audit.tObjectConfigTable where objectKey in (242,365, 363, 367, 371)
--242	acumen	fact	pIWebPurchase	evolve	web
--363	acumen	fact	pIWebNewUnique	evolve	web
--365	acumen	fact	pIWebActiveMember	evolve	web
--evolve.web.pIWebActiveMember

select * from succor.audit.tLoadTable where objectKey = 363 and dateKey = 'jan 8 2012'
and loadTableKey = 416076

select * from succor.audit.tLoadArchive where loadArchiveKey =  383412

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 2, attempts =0, 
    finishedDateTime = null, startDateTime = null where loadArchiveKey in  (383412)

select dateCreated, [cookie_id], ipAddress, adcode, user_id 
FROM [archive].web.jump_user
where loadArchiveKey = 383412

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Archive Table')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'File')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Report')

--224	Lavalife Web Affiliate Report.xlsx	Lavalife Web Affiliate Report	Report	WEB
--372	Lavalife Web Sales by Payment Type.xlsx	Lavalife Web Sales by Payment Type	Report	WEB
--386	Lavalife Web KPI Last 60 Days.xlsx	Lavalife Web KPI Last 60 Days	Report	WEB

--load archive
select * from succor.audit.tObjectConfigArchive where objectKey in (114, 367, 371)
select * from succor.audit.tObjectConfigReport where objectKey in (224, 371, 386)
select * from succor.audit.tObjectConfigReport where objectKey in (208)

--update succor.audit.tObjectConfigReport set active= 0 where objectKey in (224)

select * from succor.audit.tObjectConfig where objectKey in (224)
--update succor.audit.tObjectConfig  set endDate = 'oct 12 2011' where objectKey in (224)

--select * from succor.audit.tLoadTask where objectKey = 224

--select * from [acumen].[fact].[tIvrSales] 

select * from succor.audit.tLoadArchive where loadArchiveKey = 378832  
select * from succor.audit.tLoadArchive where loadArchiveKey = 379190  
select * from succor.audit.tLoadArchive where loadArchiveKey in (383415, 383413)
 --(379025, 379027)

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 2, attempts =0, 
    finishedDateTime = null, startDateTime = null where loadArchiveKey in  (383415, 383413)



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

--web sales
select * from succor.audit.tLoadTable
where objectKey in (242) and 
dateKey >= dateadd(day,-20,convert(char(11),getdate()))
order by objectKey,dateKey

exec succor.etl.pSLoadTable_WaitingToLoad 80

--table
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 334506
--delete from [acumen].[fact].[tIvrSales] where loadTableKey = 334506

select * from succor.audit.tLoadTable where loadTableKey = 334506
