
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
where 
objectKey in (277) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tLoadArchive
where 
objectKey in (276) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

select * from acumen.fact.tMbloxSummary where loadTableKey = 335061
select * from archive.mobile.mBloxSummary where loadArchiveKey = 304210