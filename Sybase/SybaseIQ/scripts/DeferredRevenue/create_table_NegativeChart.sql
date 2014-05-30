CREATE TABLE DeferredRev.NegativeChartFirstPurchaseJan2004 
(
  userId numeric(12,0) NOT NULL
, creditConsumed1999Apr int NULL
, creditConsumed1999May int NULL
, creditConsumed1999Jun int NULL
, creditConsumed1999Jul int NULL
, creditConsumed1999Aug int NULL
, creditConsumed1999Sep int NULL
, creditConsumed1999Oct int NULL
, creditConsumed1999Nov int NULL
, creditConsumed1999Dec int NULL
, creditConsumed2000Jan int NULL
, creditConsumed2000Feb int NULL
, creditConsumed2000Mar int NULL
, creditConsumed2000Apr int NULL
, creditConsumed2000May int NULL
, creditConsumed2000Jun int NULL
, creditConsumed2000Jul int NULL
, creditConsumed2000Aug int NULL
, creditConsumed2000Sep int NULL
, creditConsumed2000Oct int NULL
, creditConsumed2000Nov int NULL
, creditConsumed2000Dec int NULL
, creditConsumed2001Jan int NULL
, creditConsumed2001Feb int NULL
, creditConsumed2001Mar int NULL
, creditConsumed2001Apr int NULL
, creditConsumed2001May int NULL
, creditConsumed2001Jun int NULL
, creditConsumed2001Jul int NULL
, creditConsumed2001Aug int NULL
, creditConsumed2001Sep int NULL
, creditConsumed2001Oct int NULL
, creditConsumed2001Nov int NULL
, creditConsumed2001Dec int NULL
, creditConsumed2002Jan int NULL
, creditConsumed2002Feb int NULL
, creditConsumed2002Mar int NULL
, creditConsumed2002Apr int NULL
, creditConsumed2002May int NULL
, creditConsumed2002Jun int NULL
, creditConsumed2002Jul int NULL
, creditConsumed2002Aug int NULL
, creditConsumed2002Sep int NULL
, creditConsumed2002Oct int NULL
, creditConsumed2002Nov int NULL
, creditConsumed2002Dec int NULL
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
INSERT DeferredRev.NegativeChartFirstPurchaseJan2004 
(
  userId 
, creditConsumed1999Apr
, creditConsumed1999May
, creditConsumed1999Jun
, creditConsumed1999Jul
, creditConsumed1999Aug
, creditConsumed1999Sep
, creditConsumed1999Oct
, creditConsumed1999Nov
, creditConsumed1999Dec
, creditConsumed2000Jan
, creditConsumed2000Feb
, creditConsumed2000Mar
, creditConsumed2000Apr
, creditConsumed2000May
, creditConsumed2000Jun
, creditConsumed2000Jul
, creditConsumed2000Aug
, creditConsumed2000Sep
, creditConsumed2000Oct
, creditConsumed2000Nov
, creditConsumed2000Dec
, creditConsumed2001Jan
, creditConsumed2001Feb
, creditConsumed2001Mar
, creditConsumed2001Apr
, creditConsumed2001May
, creditConsumed2001Jun
, creditConsumed2001Jul
, creditConsumed2001Aug
, creditConsumed2001Sep
, creditConsumed2001Oct
, creditConsumed2001Nov
, creditConsumed2001Dec
, creditConsumed2002Jan
, creditConsumed2002Feb
, creditConsumed2002Mar
, creditConsumed2002Apr
, creditConsumed2002May
, creditConsumed2002Jun
, creditConsumed2002Jul
, creditConsumed2002Aug
, creditConsumed2002Sep
, creditConsumed2002Oct
, creditConsumed2002Nov
, creditConsumed2002Dec
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
DECLARE @RepDate  datetime
SELECT  @RepDate = convert(datetime, convert(varchar(10), 20040101))
SELECT a.userId
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 1999' and a.dateCreated <
dateadd(mm,1,'Apr 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 1999' and a.dateCreated <
dateadd(mm,1,'May 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 1999' and a.dateCreated <
dateadd(mm,1,'Jun 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 1999' and a.dateCreated <
dateadd(mm,1,'Jul 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 1999' and a.dateCreated <
dateadd(mm,1,'Aug 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 1999' and a.dateCreated <
dateadd(mm,1,'Sep 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 1999' and a.dateCreated <
dateadd(mm,1,'Oct 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 1999' and a.dateCreated <
dateadd(mm,1,'Nov 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 1999' and a.dateCreated <
dateadd(mm,1,'Dec 01, 1999' THEN a.credits ELSE 0 END) AS creditConsumed1999Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2000' and a.dateCreated <
dateadd(mm,1,'Jan 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2000' and a.dateCreated <
dateadd(mm,1,'Feb 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2000' and a.dateCreated <
dateadd(mm,1,'Mar 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2000' and a.dateCreated <
dateadd(mm,1,'Apr 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2000' and a.dateCreated <
dateadd(mm,1,'May 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2000' and a.dateCreated <
dateadd(mm,1,'Jun 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2000' and a.dateCreated <
dateadd(mm,1,'Jul 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2000' and a.dateCreated <
dateadd(mm,1,'Aug 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2000' and a.dateCreated <
dateadd(mm,1,'Sep 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2000' and a.dateCreated <
dateadd(mm,1,'Oct 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2000' and a.dateCreated <
dateadd(mm,1,'Nov 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2000' and a.dateCreated <
dateadd(mm,1,'Dec 01, 2000' THEN a.credits ELSE 0 END) AS creditConsumed2000Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2001' and a.dateCreated <
dateadd(mm,1,'Jan 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2001' and a.dateCreated <
dateadd(mm,1,'Feb 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2001' and a.dateCreated <
dateadd(mm,1,'Mar 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2001' and a.dateCreated <
dateadd(mm,1,'Apr 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2001' and a.dateCreated <
dateadd(mm,1,'May 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2001' and a.dateCreated <
dateadd(mm,1,'Jun 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2001' and a.dateCreated <
dateadd(mm,1,'Jul 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2001' and a.dateCreated <
dateadd(mm,1,'Aug 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2001' and a.dateCreated <
dateadd(mm,1,'Sep 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2001' and a.dateCreated <
dateadd(mm,1,'Oct 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2001' and a.dateCreated <
dateadd(mm,1,'Nov 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2001' and a.dateCreated <
dateadd(mm,1,'Dec 01, 2001' THEN a.credits ELSE 0 END) AS creditConsumed2001Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2002' and a.dateCreated <
dateadd(mm,1,'Jan 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2002' and a.dateCreated <
dateadd(mm,1,'Feb 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2002' and a.dateCreated <
dateadd(mm,1,'Mar 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2002' and a.dateCreated <
dateadd(mm,1,'Apr 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2002' and a.dateCreated <
dateadd(mm,1,'May 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2002' and a.dateCreated <
dateadd(mm,1,'Jun 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2002' and a.dateCreated <
dateadd(mm,1,'Jul 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2002' and a.dateCreated <
dateadd(mm,1,'Aug 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2002' and a.dateCreated <
dateadd(mm,1,'Sep 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2002' and a.dateCreated <
dateadd(mm,1,'Oct 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2002' and a.dateCreated <
dateadd(mm,1,'Nov 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2002' and a.dateCreated <
dateadd(mm,1,'Dec 01, 2002' THEN a.credits ELSE 0 END) AS creditConsumed2002Dec
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jan 01, 2003' and a.dateCreated <
dateadd(mm,1,'Jan 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Jan
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Feb 01, 2003' and a.dateCreated <
dateadd(mm,1,'Feb 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Feb
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Mar 01, 2003' and a.dateCreated <
dateadd(mm,1,'Mar 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Mar
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Apr 01, 2003' and a.dateCreated <
dateadd(mm,1,'Apr 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Apr
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'May 01, 2003' and a.dateCreated <
dateadd(mm,1,'May 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003May
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jun 01, 2003' and a.dateCreated <
dateadd(mm,1,'Jun 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Jun
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Jul 01, 2003' and a.dateCreated <
dateadd(mm,1,'Jul 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Jul
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Aug 01, 2003' and a.dateCreated <
dateadd(mm,1,'Aug 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Aug
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Sep 01, 2003' and a.dateCreated <
dateadd(mm,1,'Sep 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Sep
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Oct 01, 2003' and a.dateCreated <
dateadd(mm,1,'Oct 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Oct
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Nov 01, 2003' and a.dateCreated <
dateadd(mm,1,'Nov 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Nov
, SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'Dec 01, 2003' and a.dateCreated <
dateadd(mm,1,'Dec 01, 2003' THEN a.credits ELSE 0 END) AS creditConsumed2003Dec
FROM DeferredRev.AccountTransaction a
WHERE a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId >= 1 and a.xactionTypeId <= 4 --consumption
    and a.dateCreated < @RepDate
GROUP BY a.userId 
go
