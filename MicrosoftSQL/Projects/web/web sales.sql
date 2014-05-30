--fact.tWebActiveMember

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Fact Table')

--365	tWebActiveMember	Web - Active Members	Fact Table	WEB
--242	tWebPurchase	tWebPurchase	Fact Table	WEB
--363	tWebNewUnique	Web - New Uniques	Fact Table	WEB

--242	tWebPurchase	tWebPurchase	Fact Table	WEB
--242	acumen	fact	pIWebPurchase	evolve	web
select * from succor.audit.tLoadTable where objectKey = 242 and dateKey = 'aug 12 2012'
and loadTableKey = 494997
--and loadArchiveKey = 460464 

select * from succor.audit.tLoadArchive where --objectKey = 242 and 
dateKey = 'aug 12 2012'
and loadArchiveKey = 460464 

SELECT loadArchiveKey, sum(cost) FROM archive.web.Purchase WHERE loadArchiveKey in (460464 , 460822)
and cost < 0
group by loadArchiveKey

460464	5623.85
460822	6964.24

460464	-4925.44
460822	-1274.77

SELECT  * FROM archive.web.Purchase WHERE loadArchiveKey in (460464 , 460822)
order by loadArchiveKey

select * from succor.audit.tLoadArchive where loadArchiveKey = 410339

select * from succor.audit.tLoadTable where loadArchiveKey = 
select * from succor.audit.tLoadTable where loadTableKey = 443757

DECLARE @loadTableKey int, @results int
SELECT @loadTableKey = 
--443892 --ebNewUnique
443757--sales
EXEC [evolve].[web].[pIWebPurchase] @loadTableKey , @results output
--EXEC [evolve].[web].[pIWebNewUnique] @loadTableKey , @results output

--load table 
select * from succor.audit.tObjectConfigTable where objectKey in (242,365, 363, 367, 371)
--242	acumen	fact	pIWebPurchase	evolve	web
--363	acumen	fact	pIWebNewUnique	evolve	web
--365	acumen	fact	pIWebActiveMember	evolve	web
--evolve.web.pIWebActiveMember

select * from succor.audit.tObjectConfigArchive where objectKey in (242,365, 363, 367, 371)

select * from succor.audit.tLoadTable where objectKey = 363 and dateKey = 'jan 8 2012'
and loadTableKey = 416076

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Archive Table')

--132	UserInfo	UserInfo	Archive Table	WEB
--232	user_info	Web Member	Archive Table	WEB
--371	user_info_deleted	user_info_deleted	Archive Table	WEB
--235	SubScriptionOfferDetail	SubscriptionOfferDetail	Archive Table	WEB

select * from succor.audit.tObjectConfigArchive where objectKey in (132, 232, 371, 235)

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

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 2, attempts =0, 
    finishedDateTime = null, startDateTime = null where loadArchiveKey in  (410622, 410623)

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 2, attempts =0, 
    finishedDateTime = null, startDateTime = null 
where loadArchiveKey in (
select a.loadArchiveKey
from succor.audit.tLoadArchive a, succor.audit.vObject o
where a.objectKey = o.objectKey and a.dateKey = 'sep 12 2012' 
and (o.businessUnit = 'WEB') AND (o.objectType = 'Archive Table')
and a.statusKey = 8
)

--371 user_info_deleted 
--by pass it if there is no deleted user_info
select * from succor.audit.tLoadArchive where objectKey = 371 
and dateKey >= dateadd(day,-10,convert(char(11),getdate()))

select * from succor.audit.tLoadArchive where loadArchiveKey in  (410622, 410623)
--update succor.audit.tLoadArchive set statusKey = 7 where loadArchiveKey in  (404181, 404539)

select * from succor.audit.tLoadArchive where objectKey = 367 
and dateKey >= dateadd(day,-10,convert(char(11),getdate()))


select objectName, a.* 
from succor.audit.tLoadArchive a, succor.audit.vObject o
where a.objectKey = o.objectKey and a.dateKey = 'sep 10 2012' 
and (o.businessUnit = 'WEB') AND (o.objectType = 'Archive Table')
and a.statusKey = 8

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'WEB') AND (objectType = 'Fact Table')

--update succor.audit.tLoadArchive 
set rowCountRaw = 7341, rowCountLoaded = 7341, statusKey = 6, attempts =1, 
    minDateTime = '2011-05-31 00:00:16', maxDateTime = '2011-05-31 23:59:53',
    finishedDateTime = 'jul 21 2011 2:35pm', startDateTime = 'jul 21 2011 2:20pm' where loadArchiveKey = 303639

select min(dateModified), max(dateModified), count(*)  FROM [archive].[pos].[Activity] where loadArchiveKey = 410339
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
dateKey >= dateadd(day,-10,convert(char(11),getdate()))
order by objectKey,dateKey

exec succor.etl.pSLoadTable_WaitingToLoad 80

--table
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 334506
--delete from [acumen].[fact].[tIvrSales] where loadTableKey = 334506

select * from succor.audit.tLoadTable where loadTableKey = 443892
--loadTableKey = 443892

select * from archive.web.SubscriptionOfferDetail where subscriptionOfferDetailId in (494, 495, 406, 518, 519, 520)
order by subscriptionOfferDetailId


