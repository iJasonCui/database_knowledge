select * from succor.audit.tLoadTable
where 
objectKey in (80) and 
dateKey >= dateadd(day,-20,convert(char(11),getdate()))
order by objectKey,dateKey

--Mobile
SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'Mobile') AND (objectType = 'Fact Table')

SELECT    * --objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
where     objectKey = 277

select * from succor.audit.tLoadTable
where 
objectKey in (267) and 
dateKey >= dateadd(day,-40,convert(char(11),getdate()))
order by objectKey,dateKey

--===============================
DECLARE @RC int
DECLARE @dateKey smalldatetime
DECLARE @results int

select @dateKey = 'aug 19 2012'

EXECUTE @RC = [succor].[audit].[pIDailyLoads] 
   @dateKey
  ,@results OUTPUT
--================================