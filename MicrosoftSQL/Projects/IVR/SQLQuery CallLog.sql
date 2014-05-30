--common problem 1: "net use x: //dmvault/data " does not work, dmvault is a linux server, AS4 is windows server.
--Tait uses Samba to map network drive from dmvault.

--CallLog fact table
SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'Fact Table')
--146	tCallLog	Call Log	Fact Table	IVR

select * from succor.audit.tObjectConfigTable where objectKey in (146)
--146	acumen	fact	pICallLog	evolve	ivr

select * from succor.audit.tLoadTable
where objectKey in (146) and 
dateKey = 'feb 27 2012' -- >= dateadd(day,-10,convert(char(11),getdate()))
order by objectKey,dateKey

select * from [acumen].[fact].tCallLog where loadTableKey = 416908

DECLARE @RC int
DECLARE @loadTableKey int
DECLARE @results int

SELECT @loadTableKey = 416909
WHILE @loadTableKey <= 416949
BEGIN

--146
EXECUTE @RC = [evolve].[ivr].[pICallLog]
   @loadTableKey
  ,@results OUTPUT
SELECT @loadTableKey = @loadTableKey + 1

END

--The end of CallLog fact table

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'File')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'Report')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'Archive Table')
--63 CallLog archive table

select * from succor.audit.tLoadArchive
where 
objectKey in (63) and 
--dateKey >= dateadd(day,-10,convert(char(11),getdate()))
dateKey >= 'jul 20 2012'
order by objectKey,dateKey

select * from succor.audit.tLoadArchive
where 
objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
--and attempts = 10 
and rowCountRaw = 0 and rowCountLoaded = 0 

--update succor.audit.tLoadArchive set attempts = 0
where 
objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
and attempts = 10 and rowCountRaw = 0 and rowCountLoaded = 0 

select * from succor.audit.tObjectConfigArchive where objectKey in (63)

--load file 

select * from succor.audit.tLoadArchive where loadFileKey in (283469, 284209)

select * from archive.ivr.CallLog where loadArchiveKey in (454538)
select * from archive.ivr.CallLog where createdDateTime >= 'jul 19 2012' 
and dnis in ('+14184250325', '+14184250295', '+14168475419')
and loadArchiveKey  >= 452000

select * from succor.audit.tObjectConfigFile where objectKey in (68)
select * from succor.audit.tObjectConfigArchive where objectKey in (63)
select * from succor.audit.tObjectConfigTable --where objectKey in (68)
select * from succor.audit.tObjectConfigCube--where objectKey in (68)

--update succor.audit.tObjectConfigFile  
set vendorEmail = 'jcui@fmginc.com' , businessEmail = 'jcui@fmginc.com'


select * from succor.audit.tLoadFile
where 
objectKey in (68) and 
dateKey >= dateadd(day,-30,convert(char(11),getdate()))

select * from succor.audit.tLoadFile where loadFileKey in 
(select loadFileKey from succor.audit.tLoadArchive
where 
objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate())) and rowCountRaw = 0 and rowCountLoaded = 0)

select loadFileKey, * from succor.audit.tLoadArchive --WHERE loadFileKey = 294911
where objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate())) 
and rowCountRaw = 0 and rowCountLoaded = 0

--update succor.audit.tLoadArchive
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 0, attempts =0, finishedDateTime = null, startDateTime = null
where objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate())) and rowCountRaw = 0 and rowCountLoaded = 0

select * from succor.audit.tObject where objectKey in (68, 63)

--update  succor.audit.tLoadFile 
set rowCountRaw = 0, rowCountLoaded = 0, statusKey = 0, attempts =0, finishedDateTime = null, startDateTime = null
where loadFileKey in 
(select loadFileKey from succor.audit.tLoadArchive
where 
objectKey in (63) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate())) and rowCountRaw = 0 and rowCountLoaded = 0)
