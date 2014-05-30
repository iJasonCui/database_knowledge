
--select '2003Sep' as Month,

select '2003Sep' as Month,
SUM(creditConsumed2003Sep) as creditConsumed,
SUM(case when creditConsumed2003Sep < 0 then 1 else 0 end) as userCount,

SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May < 0 then creditConsumed2003Sep else 0 end ) as creditConsumedM3,
SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May < 0 then 1 else 0 end ) as countM3 ,

SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr < 0 then creditConsumed2003Sep else 0 end ) as creditConsumedM4,
SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr < 0 then 1 else 0 end ) as countM4 ,

SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar < 0 
then creditConsumed2003Sep else 0 end ) as creditConsumedM5,
SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar < 0 then 1 else 0 end ) as countM5,

SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar = 0  and creditConsumed2003Feb < 0
then creditConsumed2003Sep else 0 end ) as creditConsumedM6,
SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar = 0 and creditConsumed2003Feb < 0
then 1 else 0 end ) as countM6,

SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar = 0 and creditConsumed2003Feb = 0  
and firstPurchaseDate < 'Jan 1 2003' then creditConsumed2003Sep else 0 end ) as creditConsumedM7,
SUM(case when creditConsumed2003Sep < 0 and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0
and creditConsumed2003May = 0 and creditConsumed2003Apr = 0 and creditConsumed2003Mar = 0 and creditConsumed2003Feb = 0 
and firstPurchaseDate < 'Jan 1 2003' then 1 else 0 end ) as countM7

from wp_report..Jason_NegativeChart
go

--insert Negativegraph

select '2003Dec' as Month,
SUM(creditConsumed2003Dec) as creditConsumed,
SUM(case when creditConsumed2003Dec < 0 then 1 else 0 end) as userCount,

SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug < 0 then creditConsumed2003Dec else 0 end ) as creditConsumedM3,
SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug < 0 then 1 else 0 end ) as countM3 ,

SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul < 0 then creditConsumed2003Dec else 0 end ) as creditConsumedM4,
SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul < 0 then 1 else 0 end ) as countM4 ,

SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun < 0 
then creditConsumed2003Dec else 0 end ) as creditConsumedM5,
SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun < 0 then 1 else 0 end ) as countM5,

SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0  and creditConsumed2003May < 0
then creditConsumed2003Dec else 0 end ) as creditConsumedM6,
SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0 and creditConsumed2003May < 0
then 1 else 0 end ) as countM6,

SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0 and creditConsumed2003May = 0  
and firstPurchaseDate < 'Apr 1 2003' then creditConsumed2003Dec else 0 end ) as creditConsumedM7,
SUM(case when creditConsumed2003Dec < 0 and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0
and creditConsumed2003Aug = 0 and creditConsumed2003Jul = 0 and creditConsumed2003Jun = 0 and creditConsumed2003May = 0 
and firstPurchaseDate < 'Apr 1 2003' then 1 else 0 end ) as countM7

from wp_report..Jason_NegativeChart
go

--insert Negativegraph

--select '2004Jun' as Month,

select '2004Jun' as Month,
SUM(creditConsumed2004Jun) as creditConsumed,
SUM(case when creditConsumed2004Jun < 0 then 1 else 0 end) as userCount,

SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb < 0 then creditConsumed2004Jun else 0 end ) as creditConsumedM3,
SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb < 0 then 1 else 0 end ) as countM3 ,

SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan < 0 then creditConsumed2004Jun else 0 end ) as creditConsumedM4,
SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan < 0 then 1 else 0 end ) as countM4 ,

SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec < 0 
then creditConsumed2004Jun else 0 end ) as creditConsumedM5,
SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec < 0 then 1 else 0 end ) as countM5,

SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0  and creditConsumed2003Nov < 0
then creditConsumed2004Jun else 0 end ) as creditConsumedM6,
SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 and creditConsumed2003Nov < 0
then 1 else 0 end ) as countM6,

SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 and creditConsumed2003Nov = 0  
and firstPurchaseDate < 'oct 1 2003' then creditConsumed2004Jun else 0 end ) as creditConsumedM7,
SUM(case when creditConsumed2004Jun < 0 and creditConsumed2004May = 0 and creditConsumed2004Apr = 0 and creditConsumed2004Mar = 0
and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 and creditConsumed2003Nov = 0 
and firstPurchaseDate < 'oct 1 2003' then 1 else 0 end ) as countM7

from wp_report..Jason_NegativeChart
go



--insert Negativegraph

--select '2004Mar' as Month,

--select '2004Mar' as Month,

select '2004Mar' as Month,
SUM(creditConsumed2004Mar) as creditConsumed,
SUM(case when creditConsumed2004Mar < 0 then 1 else 0 end) as userCount,

SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and creditConsumed2003Nov < 0 then creditConsumed2004Mar else 0 end ) as creditConsumedM3,
SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 
         and creditConsumed2003Nov < 0 then 1 else 0 end ) as countM3 ,

SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and creditConsumed2003Nov = 0 and creditConsumed2003Oct < 0 then creditConsumed2004Mar else 0 end ) as creditConsumedM4,
SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 
         and creditConsumed2003Nov = 0 and creditConsumed2003Oct < 0 then 1 else 0 end ) as countM4 ,

SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep < 0 then creditConsumed2004Mar else 0 end ) as creditConsumedM5,
SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep < 0 then 1 else 0 end ) as countM5,

SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0 
         and  creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0  and creditConsumed2003Aug < 0 then creditConsumed2004Mar else 0 end ) as creditConsumedM6,
SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and  creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0 and creditConsumed2003Aug < 0 then 1 else 0 end ) as countM6,

SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0 and creditConsumed2003Aug = 0  
         and firstPurchaseDate < 'Jul 1 2003' then creditConsumed2004Mar else 0 end ) as creditConsumedM7,
SUM(case when creditConsumed2004Mar < 0 and creditConsumed2004Feb = 0 and creditConsumed2004Jan = 0 and creditConsumed2003Dec = 0
         and  creditConsumed2003Nov = 0 and creditConsumed2003Oct = 0 and creditConsumed2003Sep = 0 and creditConsumed2003Aug = 0 
         and firstPurchaseDate < 'Jul 1 2003' then 1 else 0 end ) as countM7

from wp_report..Jason_NegativeChart
go

