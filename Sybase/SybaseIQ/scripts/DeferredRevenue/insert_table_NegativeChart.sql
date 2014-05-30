IF OBJECT_ID('DeferredRev.NegativeChartJul2005') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.NegativeChartJul2005
END
ELSE BEGIN
   PRINT 'THERE IS NO TABLE DeferredRev.NegativeChartJul2005' 
END
go
CREATE TABLE DeferredRev.NegativeChartJul2005 
(
  userId                  numeric(12,0) NOT NULL
, dateFirstPurchased      datetime      NULL
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
INSERT DeferredRev.NegativeChartJul2005 
(
  userId 
, dateFirstPurchased
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
SELECT  a.userId
      , a.dateFirstPurchased
, b.creditConsumed2003Jan
, b.creditConsumed2003Feb
, b.creditConsumed2003Mar
, b.creditConsumed2003Apr
, b.creditConsumed2003May
, b.creditConsumed2003Jun
, b.creditConsumed2003Jul
, b.creditConsumed2003Aug
, b.creditConsumed2003Sep
, b.creditConsumed2003Oct
, b.creditConsumed2003Nov
, b.creditConsumed2003Dec
, b.creditConsumed2004Jan
, b.creditConsumed2004Feb
, b.creditConsumed2004Mar
, b.creditConsumed2004Apr
, b.creditConsumed2004May
, b.creditConsumed2004Jun
, b.creditConsumed2004Jul
, b.creditConsumed2004Aug
, b.creditConsumed2004Sep
, b.creditConsumed2004Oct
, b.creditConsumed2004Nov
, b.creditConsumed2004Dec
, b.creditConsumed2005Jan
, b.creditConsumed2005Feb
, b.creditConsumed2005Mar
, b.creditConsumed2005Apr
, b.creditConsumed2005May
, b.creditConsumed2005Jun
FROM DeferredRev.NegativeChartFirstPurchaseJul2005 a ,
DeferredRev.NegativeChartCreditUsedJul2005 b
WHERE a.userId = b.userId 
go
SELECT COUNT(*) FROM DeferredRev.NegativeChartJul2005
go
