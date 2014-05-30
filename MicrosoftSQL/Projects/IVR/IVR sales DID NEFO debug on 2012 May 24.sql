--1. I could not find where is the job to add DID, therefore I manually did it

--2. the function; FROM [tool].[fLookupDidKeys](@startDate)
   select * FROM [evolve].[tool].[fLookupDidKeys]('apr 1 2012') where dialedIdentificationNumber = '6463504387'
--3. behind the function is a table:  

SELECT * FROM [archive].[dm].[DID] where activationDate <= 'jan 1 2012' 
and deActivationDate > 'jan 1 2012' and cityId = 10
and productId = 5

/*
--4. if there is new DNIS in archive.pos.ActivityOther, but not in [archive].[dm].[DID].
     it will cause problem that cityKey will be =0; paymentTypeKey will be =-1
*/

--5. find out what are the new DNIS, but not insert into [archive].[dm].[DID]

select ao.DNIS, count(*), sum(a.totalPrice)
from archive.pos.Activity a, archive.pos.ActivityOther ao
where a.activityId = ao.activityId and a.dateCreated >= 'apr 1 2012' and a.dateCreated < 'may 1 2012' and a.cityId = 10 and a.productId = 5
group by ao.DNIS
--result
+16463504387             	1279	330.75  ??
+16466667776             	1	0.00        x
+19173383597             	475	179.60      x
+19173383601             	879	833.30      x
+19173383602             	4	0.40        x
+19173383604             	5792	2763.50 x

select ao.DNIS, count(*), sum(a.totalPrice)
from archive.pos.Activity a, archive.pos.ActivityOther ao
where a.activityId = ao.activityId and a.dateCreated >= 'mar 1 2012' and a.dateCreated < 'apr 1 2012'
and a.cityId = 10 and a.productId = 5
group by ao.DNIS
--result
+16466667776             	6	0.00
+19173383598             	3	0.35
+16462572252             	3	0.00
+16463504200             	17	0.00
+19173383601             	1097	1107.60 x
+19173383602             	5	0.75        x
+16463504387             	1496	381.30  ??
+19173383597             	492	173.95      x
+19173383604             	6160	2798.45 x

--6. insert into [archive].[dm].[DID]

select * from [archive].[dm].[DID] 
where dialedIdentificationNumber in (
'6463504200',
'6462572252',  
'6462334878',
'6463504387',
'6466667776',
'9173383602',
'9173383601',
'9173383604',
'9173383597',
'9173383598')

--7. '6463504387'
select max(didId) from [archive].[dm].[DID] 
--46088

INSERT INTO [archive].[dm].[DID]
           ([didId]
           ,[dialedIdentificationNumber]
           ,[cityId]
           ,[productId]
           ,[activationDate]
           ,[deActivationDate]
           ,[telcoId]
           ,[btn]
           ,[description]
           ,[tollFreeNumber]
           ,[productLeadNumber]
           ,[advertisedNumber]
           ,[ivrStartDate]
           ,[ivrEndDate]
           ,[partnershipId]
           ,[courtesyResponseIndicator]
           ,[routingCompletionDate]
           ,[marketingName]
           ,[callFlowId]
           ,[tollFreeBilling]
           ,[platformCode]
           ,[price]
           ,[dateModified]
           ,[modifiedBy]
           ,[payTypeId]
           ,[channelId]
           ,[carrierKey]
           ,[didDescription]
           ,[daBillingRuleKey]
           ,[defaultApMode])
SELECT 
           46088+1 --[didId]
           ,'6463504387' --[dialedIdentificationNumber]
           ,[cityId]
           ,[productId]
           ,[activationDate]
           ,[deActivationDate]
           ,[telcoId]
           ,[btn]
           ,[description]
           ,[tollFreeNumber]
           ,[productLeadNumber]
           ,'6463504387' --[advertisedNumber]
           ,[ivrStartDate]
           ,[ivrEndDate]
           ,[partnershipId]
           ,[courtesyResponseIndicator]
           ,[routingCompletionDate]
           ,[marketingName]
           ,[callFlowId]
           ,[tollFreeBilling]
           ,[platformCode]
           ,[price]
           ,[dateModified]
           ,[modifiedBy]
           ,[payTypeId]
           ,[channelId]
           ,[carrierKey]
           ,[didDescription]
           ,[daBillingRuleKey]
           ,[defaultApMode]
FROM [archive].[dm].[DID] 
where dialedIdentificationNumber in ('6463504200')

--insert into [acumen].[dim].[tIvrDID]
INSERT INTO [acumen].[dim].[tIvrDID]
           ([didId]
           ,[npa]
           ,[nxx]
           ,[dnis]
           ,[partnershipId]
           ,[partnership]
           ,[parentPartnership]
           ,[carrierKey]
           ,[productKey]
           ,[callFlowKey]
           ,[dateModified]
           ,[cityId])
SELECT  46088+1 --[didId]
           ,[npa]
           ,[nxx]
           ,'(646) 350-4387 NYC NE Triton Level(3) [46089]' --,[dnis]
           ,[partnershipId]
           ,[partnership]
           ,[parentPartnership]
           ,[carrierKey]
           ,[productKey]
           ,[callFlowKey]
           ,[dateModified]
           ,[cityId]
FROM [acumen].[dim].[tIvrDID] where didId = 34235

--update 
select * from acumen.fact.vIvrSales
where productionId in (
select --evolve.[tool].[fCleanPhoneNumber](ao.DNIS) as dnis, 
a.activityId
from archive.pos.Activity a, archive.pos.ActivityOther ao
where a.activityId = ao.activityId and a.dateCreated >= 'apr 1 2012' and a.dateCreated < 'may 1 2012'
and a.cityId = 10 and a.productId = 5
)
and objectKey = 92

SELECT evolve.[tool].[fCleanPhoneNumber](ao.DNIS) as dnis, v.*
from acumen.fact.vIvrSales v, archive.pos.Activity a, archive.pos.ActivityOther ao
WHERE a.activityId = v.productionId 
  AND a.activityId = ao.activityId and a.dateCreated >= 'apr 1 2012' and a.dateCreated < 'may 31 2012'
  AND a.cityId = 10 and a.productId = 5
  AND v.objectKey = 92 and v.cityId = 0
order by estDateKey, dnis

SELECT evolve.[tool].[fCleanPhoneNumber](ao.DNIS) as dnis, v.productionId,
d.cityId, d.payTypeId
into archive.dbo.fix2012May24
from acumen.fact.tIvrSales v, archive.pos.Activity a, archive.pos.ActivityOther ao, [archive].[dm].[DID] d
WHERE a.activityId = v.productionId 
  AND a.activityId = ao.activityId and a.dateCreated >= 'apr 1 2012' 
  AND a.cityId = 10 and a.productId = 5
  AND d.dialedIdentificationNumber = evolve.[tool].[fCleanPhoneNumber](ao.DNIS)

SELECT evolve.[tool].[fCleanPhoneNumber](ao.DNIS) as dnis, v.productionId,
d.cityId, d.payTypeId
into archive.dbo.fix2012Jan_Mar
from acumen.fact.tIvrSales v, archive.pos.Activity a, archive.pos.ActivityOther ao, [archive].[dm].[DID] d
WHERE a.activityId = v.productionId 
  AND a.activityId = ao.activityId and a.dateCreated >= 'Jan 1 2012' and a.dateCreated < 'Apr 1 2012'
  AND a.cityId = 10 and a.productId = 5
  AND d.dialedIdentificationNumber = evolve.[tool].[fCleanPhoneNumber](ao.DNIS)

--UPDATE acumen.fact.tIvrSales
SET  cityId = 10, paymentTypeKey =  f.payTypeId
from acumen.fact.tIvrSales t, archive.dbo.fix2012May24 f
WHERE t.productionId = f.productionId
   AND t.cityId = 0 and t.paymentTypeKey = -1
  
--UPDATE acumen.fact.tIvrSales
SET  cityId = 10, paymentTypeKey =  f.payTypeId
from acumen.fact.tIvrSales t, archive.dbo.fix2012Jan_Mar f
WHERE t.productionId = f.productionId

select t.cityId, f.cityId, t.paymentTypeKey, f.payTypeId
from acumen.fact.tIvrSales t, archive.dbo.fix2012Jan_Mar f
WHERE t.productionId = f.productionId
  

--
SELECT    objectKey, objectName, object, objectType, businessUnit
FROM      succor.audit.vObject
WHERE     (objectType = 'Measure Group') and (businessUnit = 'IVR') 
select * from succor.audit.tLoadTable
where objectKey in (80) and 
dateKey >= dateadd(day,-10,convert(char(11),getdate()))
order by objectKey,dateKey

--
set showplan_all off;
set rowcount 0
SELECT paymentTypeKey,productKey, count(*), sum(totalPrice)
from acumen.fact.vIvrSales WHERE  estDateKey >= 'apr 1 2012' and objectKey = 92 
--and paymentTypeKey = 143
and cityId = 10
--and productKey = 51
--and productionId =57722696
and totalPrice > 0
group by paymentTypeKey, productKey
order by paymentTypeKey


--table
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 412830
select * from [acumen].[fact].[tIvrSales] where loadTableKey = 412464
--delete from [acumen].[fact].[tIvrSales] where loadTableKey = 334506

select * from succor.audit.tLoadTable where loadTableKey = 412098
select * from succor.audit.tLoadTable where loadArchiveKey = 348502

select * from succor.audit.tLoadCube where loadTableKey = 412098
select * from succor.audit.tLoadCube where loadCubeKey = 394281

