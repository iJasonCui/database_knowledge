--
select * from succor.audit.tLoadTable
where objectKey in (80) and 
dateKey >= dateadd(day,-8,convert(char(11),getdate()))
order by objectKey,dateKey
--loadArchiveKey = 418926
--loadTableKey = 452358

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject where objectKey = 92

SELECT     * FROM      succor.audit.tObjectConfigTable where objectKey = 29

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE   (objectType = 'Fact Table') and (businessUnit = 'IVR')  

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (objectType = 'Archive Table') and (businessUnit = 'IVR') 

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'File')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (objectType = 'Cube') and (businessUnit = 'IVR') 
--91	IVR Main	 IVR Main	Cube	IVR
--175	SMSBlast	SMS Blast	Cube	IVR

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (objectType = 'Measure Group') and (businessUnit = 'IVR') 


--load archive
select * from succor.audit.tLoadArchive 
--where objectKey in (70) and --Archive_Activity
where objectKey in (70,71) and --Archive_ActivityOther
dateKey >= dateadd(day,-10,convert(char(11),getdate()))
order by objectKey,dateKey

select * from succor.audit.tObjectConfigArchive where objectKey in (63, 70, 71)
--63	CallLog	E:\Projects\SSIS\IVR\IVR\	archive	ivr	createdDateTime               	1	1	0	0	-1	
--70	Archive_Activity	E:\Projects\SSIS\IVR\IVR\	archive	pos	dateModified                  	1	0	0	1	-1	
--71	Archive_ActivityOther	E:\Projects\SSIS\IVR\IVR\	archive	pos	dateModified                  	1	0	0	1	-1	

--select * from [acumen].[fact].[tIvrSales] 
where loadTableKey = 452358

--loadArchiveKey = 418926
--loadTableKey = 452358
select * from succor.audit.tLoadArchive where loadArchiveKey = 418926  --Activity
select * from succor.audit.tLoadArchive where loadArchiveKey = 303640  --ActivityOther

--update succor.audit.tLoadArchive 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 2, attempts =0, 
  finishedDateTime = null, startDateTime = null where loadArchiveKey IN (345171, 346245, 349109, 349468,349110, 349469)

--70
select *  FROM [archive].[pos].[Activity] where loadArchiveKey = 418926 
--71
select *  FROM [archive].[pos].[ActivityOther] where loadArchiveKey = 303640

exec succor.etl.pSLoadArchive_WaitingToLoad 70
exec succor.etl.pSLoadArchive32Bit_WaitingToLoad 70

--update succor.audit.tLoadArchive 
set statusKey = 0, attempts = 0, finishedDateTime = null where loadArchiveKey = 303639

--load table 
select * from succor.audit.tObjectConfigTable 
where procedureSchemaName = 'ivr' and objectKey in (75, 80, 102, 308, 316)
select * from succor.audit.tObjectConfigArchive where objectKey in (70, 71, 99, 188, 216, 231, 307)

--begin tran jason
--update succor.audit.tLoadArchive 
set statusKey = 2, attempts = 0, startDateTime = null,finishedDateTime = null where
objectKey in (select objectKey from succor.audit.tObjectConfigArchive where schemaName in ('pos', 'cm'))
and dateKey = 'Aug 12 2012'
--commit tran jason

select * from succor.audit.tLoadArchive where objectKey in (
select objectKey from succor.audit.tObjectConfigArchive where schemaName in ('pos', 'cm'))
and dateKey in ('Aug 12 2012')

--load table 
select * from succor.audit.tLoadTable  where objectKey in (
select objectKey from succor.audit.tObjectConfigTable where schemaName in ('pos', 'cm'))
and dateKey = 'Aug 11 2012'

select * from succor.audit.tObjectConfigCube where objectKey in (268, 29)

--load dimension
select * from succor.audit.tObjectConfigDimension where objectKey in (61)

select * from succor.audit.tLoadTable
where objectKey in (75) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

exec succor.etl.pSLoadTable_WaitingToLoad 80

--table
--loadArchiveKey = 418926
--loadTableKey = 452358
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 452358
delete from [acumen].[fact].[tIvrSales] where loadTableKey = 452358
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 412464
--delete from [acumen].[fact].[tIvrSales] where loadTableKey = 334506

select * from succor.audit.tLoadTable where loadTableKey = 412098
select * from succor.audit.tLoadTable where loadArchiveKey = 348502

select * from succor.audit.tLoadCube where loadTableKey = 412098
select * from succor.audit.tLoadCube where loadCubeKey = 394281

--update  succor.audit.tLoadCube set attempts = 0 where loadCubeKey = 394188
select * from succor.audit.tLoadCube 
where objectKey = 92 and dateKey > 'mar 1 2012' --dateadd(dd, -1000, getdate())
and attempts > 0 
