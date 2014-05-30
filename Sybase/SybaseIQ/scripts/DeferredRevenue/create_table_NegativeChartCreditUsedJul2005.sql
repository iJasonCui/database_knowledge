IF OBJECT_ID('DeferredRev.NegativeChartCreditUsedJul2005') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.NegativeChartCreditUsedJul2005
END
ELSE BEGIN
   PRINT 'THERE IS NO TABLE DeferredRev.NegativeChartCreditUsedJul2005' 
END
go
CREATE TABLE DeferredRev.NegativeChartCreditUsedJul2005 
(
  userId numeric(12,0) NOT NULL
, creditConsumed2003Jan int NULL
, creditConsumed2003Feb int NULL
, creditConsumed2003Mar int NULL
, creditConsumed2003Apr int NULL
, creditConsumed2003May int NULL
, creditConsumed2003Jun int NULL
, creditConsumed2003Jul int NULL
, creditConsumed2003Aug int NULL
, creditConsumed2003Sep int NULL
, creditConsumed2003Oct int NULL
, creditConsumed2003Nov int NULL
, creditConsumed2003Dec int NULL
, creditConsumed2004Jan int NULL
, creditConsumed2004Feb int NULL
, creditConsumed2004Mar int NULL
, creditConsumed2004Apr int NULL
, creditConsumed2004May int NULL
, creditConsumed2004Jun int NULL
, creditConsumed2004Jul int NULL
, creditConsumed2004Aug int NULL
, creditConsumed2004Sep int NULL
, creditConsumed2004Oct int NULL
, creditConsumed2004Nov int NULL
, creditConsumed2004Dec int NULL
, creditConsumed2005Jan int NULL
, creditConsumed2005Feb int NULL
, creditConsumed2005Mar int NULL
, creditConsumed2005Apr int NULL
, creditConsumed2005May int NULL
, creditConsumed2005Jun int NULL
)
go
DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), 20050701))
INSERT DeferredRev.NegativeChartCreditUsedJul2005 
(
  userId 
, creditConsumed2003Jan
, creditConsumed2003Feb
, creditConsumed2003Mar
, creditConsumed2003Apr
, creditConsumed2003May
, creditConsumed2003Jun
, creditConsumed2003Jul
, creditConsumed2003Aug
, creditConsumed2003Sep
, creditConsumed2003Oct
, creditConsumed2003Nov
, creditConsumed2003Dec
, creditConsumed2004Jan
, creditConsumed2004Feb
, creditConsumed2004Mar
, creditConsumed2004Apr
, creditConsumed2004May
, creditConsumed2004Jun
, creditConsumed2004Jul
, creditConsumed2004Aug
, creditConsumed2004Sep
, creditConsumed2004Oct
, creditConsumed2004Nov
, creditConsumed2004Dec
, creditConsumed2005Jan
, creditConsumed2005Feb
, creditConsumed2005Mar
, creditConsumed2005Apr
, creditConsumed2005May
, creditConsumed2005Jun
)
SELECT a.userId
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2003') and a.dateCreated
< dateadd(mm,1,'Jan 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2003') and a.dateCreated
< dateadd(mm,1,'Feb 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2003') and a.dateCreated
< dateadd(mm,1,'Mar 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2003') and a.dateCreated
< dateadd(mm,1,'Apr 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2003') and a.dateCreated
< dateadd(mm,1,'May 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2003') and a.dateCreated
< dateadd(mm,1,'Jun 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2003') and a.dateCreated
< dateadd(mm,1,'Jul 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2003') and a.dateCreated
< dateadd(mm,1,'Aug 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2003') and a.dateCreated
< dateadd(mm,1,'Sep 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2003') and a.dateCreated
< dateadd(mm,1,'Oct 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2003') and a.dateCreated
< dateadd(mm,1,'Nov 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2003') and a.dateCreated
< dateadd(mm,1,'Dec 01, 2003') THEN a.credits ELSE 0 END) AS
creditConsumed2003Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2004') and a.dateCreated
< dateadd(mm,1,'Jan 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2004') and a.dateCreated
< dateadd(mm,1,'Feb 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2004') and a.dateCreated
< dateadd(mm,1,'Mar 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2004') and a.dateCreated
< dateadd(mm,1,'Apr 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2004') and a.dateCreated
< dateadd(mm,1,'May 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2004') and a.dateCreated
< dateadd(mm,1,'Jun 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2004') and a.dateCreated
< dateadd(mm,1,'Jul 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2004') and a.dateCreated
< dateadd(mm,1,'Aug 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2004') and a.dateCreated
< dateadd(mm,1,'Sep 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2004') and a.dateCreated
< dateadd(mm,1,'Oct 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2004') and a.dateCreated
< dateadd(mm,1,'Nov 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2004') and a.dateCreated
< dateadd(mm,1,'Dec 01, 2004') THEN a.credits ELSE 0 END) AS
creditConsumed2004Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2005') and a.dateCreated
< dateadd(mm,1,'Jan 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2005') and a.dateCreated
< dateadd(mm,1,'Feb 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2005') and a.dateCreated
< dateadd(mm,1,'Mar 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2005') and a.dateCreated
< dateadd(mm,1,'Apr 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2005') and a.dateCreated
< dateadd(mm,1,'May 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2005') and a.dateCreated
< dateadd(mm,1,'Jun 01, 2005') THEN a.credits ELSE 0 END) AS
creditConsumed2005Jun
FROM DeferredRev.AccountTransaction a
WHERE a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId in (1,2,3,4,21,22,23,24,25,26,28) --consumption
    and a.dateCreated < @RepDate
GROUP BY a.userId 
go
SELECT COUNT(*) FROM DeferredRev.NegativeChartCreditUsedJul2005
go
