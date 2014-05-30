SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'Fact Table')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'Archive Table')

SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (businessUnit = 'IVR') AND (objectType = 'File')

select * 
--from [acumen].[fact].[vCallLog_Inquiry] i 
from [acumen].[fact].[tIvrInquiry] i 
where i.dateKey >= '2010-09-25'
 --and  i.dateKey <= 'sep 28 2011'