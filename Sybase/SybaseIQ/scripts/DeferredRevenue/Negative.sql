select userId,
    min(dateCreated) as firstPurchaseDate,
   0 as creditConsumed1999Apr,
   0 as creditConsumed1999May,
   0 as creditConsumed1999Jun,
   0 as creditConsumed1999Jul,
   0 as creditConsumed1999Aug,
   0 as creditConsumed1999Sep,
   0 as creditConsumed1999Oct,
   0 as creditConsumed1999Nov,
   0 as creditConsumed1999Dec,
   0 as creditConsumed2000Jan,
   0 as creditConsumed2000Feb,
   0 as creditConsumed2000Mar,
   0 as creditConsumed2000Apr,
   0 as creditConsumed2000May,
   0 as creditConsumed2000Jun,
   0 as creditConsumed2000Jul,
   0 as creditConsumed2000Aug,
   0 as creditConsumed2000Sep,
   0 as creditConsumed2000Oct,
   0 as creditConsumed2000Nov,
   0 as creditConsumed2000Dec,
   0 as creditConsumed2001Jan,
   0 as creditConsumed2001Feb,
   0 as creditConsumed2001Mar,
   0 as creditConsumed2001Apr,
   0 as creditConsumed2001May,
   0 as creditConsumed2001Jun,
   0 as creditConsumed2001Jul,
   0 as creditConsumed2001Aug,
   0 as creditConsumed2001Sep,
   0 as creditConsumed2001Oct,
   0 as creditConsumed2001Nov,
   0 as creditConsumed2001Dec,
   0 as creditConsumed2002Jan,
   0 as creditConsumed2002Feb,
   0 as creditConsumed2002Mar,
   0 as creditConsumed2002Apr,
   0 as creditConsumed2002May,
   0 as creditConsumed2002Jun,
   0 as creditConsumed2002Jul,
   0 as creditConsumed2002Aug,
   0 as creditConsumed2002Sep,
   0 as creditConsumed2002Oct,
   0 as creditConsumed2002Nov,
   0 as creditConsumed2002Dec,
   0 as creditConsumed2003Jan,
   0 as creditConsumed2003Feb,
   0 as creditConsumed2003Mar,
   0 as creditConsumed2003Apr,
   0 as creditConsumed2003May,
   0 as creditConsumed2003Jun,
   0 as creditConsumed2003Jul,
   0 as creditConsumed2003Aug,
   0 as creditConsumed2003Sep,
   0 as creditConsumed2003Oct,
   0 as creditConsumed2003Nov,
   0 as creditConsumed2003Dec
INTO temp_jason_NegativeChart
FROM arch_Accounting..Purchase (INDEX XAK3Purchase)
WHERE xactionTypeId = 6 --purchase
    and dateCreated < "feb 1 2004"
GROUP BY userId 

delete from wp_report..temp_jason_NegativeChart 
where userId not in (select userId from WebDeferredRev..PositiveChartAsOf2004Feb01 )


--monthly consumption
SELECT a.userId,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/04/01') and a.dateCreated < dateadd(mm,1,'1999/04/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/05/01') and a.dateCreated < dateadd(mm,1,'1999/05/01') THEN a.credits ELSE 0 END) AS creditConsumed1999May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/06/01') and a.dateCreated < dateadd(mm,1,'1999/06/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/07/01') and a.dateCreated < dateadd(mm,1,'1999/07/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/08/01') and a.dateCreated < dateadd(mm,1,'1999/08/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/09/01') and a.dateCreated < dateadd(mm,1,'1999/09/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/10/01') and a.dateCreated < dateadd(mm,1,'1999/10/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/11/01') and a.dateCreated < dateadd(mm,1,'1999/11/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'1999/12/01') and a.dateCreated < dateadd(mm,1,'1999/12/01') THEN a.credits ELSE 0 END) AS creditConsumed1999Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/01/01') and a.dateCreated < dateadd(mm,1,'2000/01/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/02/01') and a.dateCreated < dateadd(mm,1,'2000/02/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/03/01') and a.dateCreated < dateadd(mm,1,'2000/03/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/04/01') and a.dateCreated < dateadd(mm,1,'2000/04/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/05/01') and a.dateCreated < dateadd(mm,1,'2000/05/01') THEN a.credits ELSE 0 END) AS creditConsumed2000May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/06/01') and a.dateCreated < dateadd(mm,1,'2000/06/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/07/01') and a.dateCreated < dateadd(mm,1,'2000/07/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/08/01') and a.dateCreated < dateadd(mm,1,'2000/08/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/09/01') and a.dateCreated < dateadd(mm,1,'2000/09/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/10/01') and a.dateCreated < dateadd(mm,1,'2000/10/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/11/01') and a.dateCreated < dateadd(mm,1,'2000/11/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2000/12/01') and a.dateCreated < dateadd(mm,1,'2000/12/01') THEN a.credits ELSE 0 END) AS creditConsumed2000Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/01/01') and a.dateCreated < dateadd(mm,1,'2001/01/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/02/01') and a.dateCreated < dateadd(mm,1,'2001/02/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/03/01') and a.dateCreated < dateadd(mm,1,'2001/03/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/04/01') and a.dateCreated < dateadd(mm,1,'2001/04/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/05/01') and a.dateCreated < dateadd(mm,1,'2001/05/01') THEN a.credits ELSE 0 END) AS creditConsumed2001May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/06/01') and a.dateCreated < dateadd(mm,1,'2001/06/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/07/01') and a.dateCreated < dateadd(mm,1,'2001/07/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/08/01') and a.dateCreated < dateadd(mm,1,'2001/08/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/09/01') and a.dateCreated < dateadd(mm,1,'2001/09/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/10/01') and a.dateCreated < dateadd(mm,1,'2001/10/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/11/01') and a.dateCreated < dateadd(mm,1,'2001/11/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2001/12/01') and a.dateCreated < dateadd(mm,1,'2001/12/01') THEN a.credits ELSE 0 END) AS creditConsumed2001Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/01/01') and a.dateCreated < dateadd(mm,1,'2002/01/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/02/01') and a.dateCreated < dateadd(mm,1,'2002/02/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/03/01') and a.dateCreated < dateadd(mm,1,'2002/03/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/04/01') and a.dateCreated < dateadd(mm,1,'2002/04/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/05/01') and a.dateCreated < dateadd(mm,1,'2002/05/01') THEN a.credits ELSE 0 END) AS creditConsumed2002May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/06/01') and a.dateCreated < dateadd(mm,1,'2002/06/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/07/01') and a.dateCreated < dateadd(mm,1,'2002/07/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/08/01') and a.dateCreated < dateadd(mm,1,'2002/08/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/09/01') and a.dateCreated < dateadd(mm,1,'2002/09/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/10/01') and a.dateCreated < dateadd(mm,1,'2002/10/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/11/01') and a.dateCreated < dateadd(mm,1,'2002/11/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2002/12/01') and a.dateCreated < dateadd(mm,1,'2002/12/01') THEN a.credits ELSE 0 END) AS creditConsumed2002Dec,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/01/01') and a.dateCreated < dateadd(mm,1,'2003/01/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Jan,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/02/01') and a.dateCreated < dateadd(mm,1,'2003/02/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Feb,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/03/01') and a.dateCreated < dateadd(mm,1,'2003/03/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Mar,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/04/01') and a.dateCreated < dateadd(mm,1,'2003/04/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Apr,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/05/01') and a.dateCreated < dateadd(mm,1,'2003/05/01') THEN a.credits ELSE 0 END) AS creditConsumed2003May,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/06/01') and a.dateCreated < dateadd(mm,1,'2003/06/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Jun,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/07/01') and a.dateCreated < dateadd(mm,1,'2003/07/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Jul,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/08/01') and a.dateCreated < dateadd(mm,1,'2003/08/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Aug,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/09/01') and a.dateCreated < dateadd(mm,1,'2003/09/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Sep,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/10/01') and a.dateCreated < dateadd(mm,1,'2003/10/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Oct,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/11/01') and a.dateCreated < dateadd(mm,1,'2003/11/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Nov,
  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0,'2003/12/01') and a.dateCreated < dateadd(mm,1,'2003/12/01') THEN a.credits ELSE 0 END) AS creditConsumed2003Dec
INTO temp_jason_NegativeConsumption
FROM wp_report..AccountTransaction a, temp_jason_NegativeChart b
WHERE a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId >= 1 and a.xactionTypeId <= 4 --consumption
    and a.dateCreated < "feb 1 2004"
    and a.userId = b.userId
GROUP BY a.userId 

--753104 row(s) affected.

--update credit consumption info
UPDATE wp_report..temp_jason_NegativeChart
SET 
    c.creditConsumed1999Apr = a.creditConsumed1999Apr,
    c.creditConsumed1999May = a.creditConsumed1999May,
    c.creditConsumed1999Jun = a.creditConsumed1999Jun,
    c.creditConsumed1999Jul = a.creditConsumed1999Jul,
    c.creditConsumed1999Aug = a.creditConsumed1999Aug,
    c.creditConsumed1999Sep = a.creditConsumed1999Sep,
    c.creditConsumed1999Oct = a.creditConsumed1999Oct,
    c.creditConsumed1999Nov = a.creditConsumed1999Nov,
    c.creditConsumed1999Dec = a.creditConsumed1999Dec,
    c.creditConsumed2000Jan = a.creditConsumed2000Jan,
    c.creditConsumed2000Feb = a.creditConsumed2000Feb,
    c.creditConsumed2000Mar = a.creditConsumed2000Mar,
    c.creditConsumed2000Apr = a.creditConsumed2000Apr,
    c.creditConsumed2000May = a.creditConsumed2000May,
    c.creditConsumed2000Jun = a.creditConsumed2000Jun,
    c.creditConsumed2000Jul = a.creditConsumed2000Jul,
    c.creditConsumed2000Aug = a.creditConsumed2000Aug,
    c.creditConsumed2000Sep = a.creditConsumed2000Sep,
    c.creditConsumed2000Oct = a.creditConsumed2000Oct,
    c.creditConsumed2000Nov = a.creditConsumed2000Nov,
    c.creditConsumed2000Dec = a.creditConsumed2000Dec,
    c.creditConsumed2001Jan = a.creditConsumed2001Jan,
    c.creditConsumed2001Feb = a.creditConsumed2001Feb,
    c.creditConsumed2001Mar = a.creditConsumed2001Mar,
    c.creditConsumed2001Apr = a.creditConsumed2001Apr,
    c.creditConsumed2001May = a.creditConsumed2001May,
    c.creditConsumed2001Jun = a.creditConsumed2001Jun,
    c.creditConsumed2001Jul = a.creditConsumed2001Jul,
    c.creditConsumed2001Aug = a.creditConsumed2001Aug,
    c.creditConsumed2001Sep = a.creditConsumed2001Sep,
    c.creditConsumed2001Oct = a.creditConsumed2001Oct,
    c.creditConsumed2001Nov = a.creditConsumed2001Nov,
    c.creditConsumed2001Dec = a.creditConsumed2001Dec,
    c.creditConsumed2002Jan = a.creditConsumed2002Jan,
    c.creditConsumed2002Feb = a.creditConsumed2002Feb,
    c.creditConsumed2002Mar = a.creditConsumed2002Mar,
    c.creditConsumed2002Apr = a.creditConsumed2002Apr,
    c.creditConsumed2002May = a.creditConsumed2002May,
    c.creditConsumed2002Jun = a.creditConsumed2002Jun,
    c.creditConsumed2002Jul = a.creditConsumed2002Jul,
    c.creditConsumed2002Aug = a.creditConsumed2002Aug,
    c.creditConsumed2002Sep = a.creditConsumed2002Sep,
    c.creditConsumed2002Oct = a.creditConsumed2002Oct,
    c.creditConsumed2002Nov = a.creditConsumed2002Nov,
    c.creditConsumed2002Dec = a.creditConsumed2002Dec,
    c.creditConsumed2003Jan = a.creditConsumed2003Jan,
    c.creditConsumed2003Feb = a.creditConsumed2003Feb,
    c.creditConsumed2003Mar = a.creditConsumed2003Mar,
    c.creditConsumed2003Apr = a.creditConsumed2003Apr,
    c.creditConsumed2003May = a.creditConsumed2003May,
    c.creditConsumed2003Jun = a.creditConsumed2003Jun,
    c.creditConsumed2003Jul = a.creditConsumed2003Jul,
    c.creditConsumed2003Aug = a.creditConsumed2003Aug,
    c.creditConsumed2003Sep = a.creditConsumed2003Sep,
    c.creditConsumed2003Oct = a.creditConsumed2003Oct,
    c.creditConsumed2003Nov = a.creditConsumed2003Nov,
    c.creditConsumed2003Dec = a.creditConsumed2003Dec
FROM wp_report..temp_jason_NegativeChart c, temp_jason_NegativeConsumption a
where c.userId = a.userId

--753104 row(s) affected.


insert Negativegraph

select '${i}' as city , 'DEC03' as Month,
SUM(case when creditConsumedDEC03 > 0 then creditConsumedDEC03 else 0 end) as creditConsumed,
COUNT(case when creditConsumedDEC03 > 0 then creditConsumedDEC03 else 0 end) as userCount,

SUM(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 > 0 then creditConsumedDEC03 else 0 end ) as creditConsumedM3,
COUNT(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 > 0
then creditConsumedDEC03 else Null end ) as countM3 ,

SUM(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 > 0
then creditConsumedDEC03 else 0 end ) as creditConsumedM4,
COUNT(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 > 0
then creditConsumedDEC03 else Null end ) as countM4 ,

SUM(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 > 0
then creditConsumedDEC03 else 0 end ) as creditConsumedM5,
COUNT(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 > 0
then creditConsumedDEC03 else Null end ) as countM5,


SUM(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 = 0  and creditConsumedMAY03 > 0
then creditConsumedDEC03 else 0 end ) as creditConsumedM6,
COUNT(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 = 0 and creditConsumedMAY03 > 0
then creditConsumedDEC03 else Null end ) as countM6,

SUM(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 = 0 and creditConsumedMAY03 = 0  and dateFirstPurcha
se < 'Apr 1 2003'
then creditConsumedDEC03 else 0 end ) as creditConsumedM7,
COUNT(case when creditConsumedDEC03 > 0 and creditConsumedNOV03 = 0 and creditConsumedOCT03 = 0 and creditConsumedSEP03 = 0
and creditConsumedAUG03 = 0 and creditConsumedJUL03 = 0 and creditConsumedJUN03 = 0 and creditConsumedMAY03 = 0 and dateFirstPurchas
e < 'Apr 1 2003'
then creditConsumedDEC03 else Null end ) as countM7

from ConsumMonth${i}





--==== generate code
set nocount on
declare @counter int
DECLARE @startDate datetime
DECLARE @month  char(3)
DECLARE @year   char(4)
DECLARE @return_result varchar(250)

select @counter = 1
select @startDate = "apr 1 1999"

while @startDate < "Jan 1 2004"
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = "   0 as creditConsumed" +  @year + @month + ","
    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end



--SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateLastPurchased) and a.dateCreated < dateadd(dd,1,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumed1999Apr,
set nocount on
DECLARE @startDate datetime
DECLARE @month  char(3)
DECLARE @year   char(4)
DECLARE @return_result varchar(250)

select @startDate = "apr 1 1999"

while @startDate < "Jan 1 2004"
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = "  SUM(CASE WHEN a.dateCreated >= dateadd(mm,0," + "'" + convert(varchar(12),@startDate,111) +"'" 
        + " and a.dateCreated < dateadd(mm,1," + "'" + convert(varchar(12),@startDate,111) +"'"
        + " THEN a.credits ELSE 0 END) AS creditConsumed" + @year + @month + ","

    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

--update credit consumption

set nocount on
DECLARE @startDate datetime
DECLARE @month  char(3)
DECLARE @year   char(4)
DECLARE @return_result varchar(250)

select @startDate = "apr 1 1999"

while @startDate < "Jan 1 2004"
begin
    select @month = substring(datename(mm, @startDate),1,3) 
    select @year = datename(yy, @startDate)
    select @return_result = "    c.creditConsumed" + @year + @month + " = a.creditConsumed" + @year + @month + ","
    print @return_result
    select @startDate = dateadd(mm,1,@startDate)
end

