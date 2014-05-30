--final result:

select 
    sum(BalanceSep99) as Balsep99,
    sum(BalanceSep00) as Balsep00,
    sum(BalanceSep01) as Balsep01,
    sum(BalanceJun02) as BalJun02,
    sum(BalanceSep02) as BalSep02 ,
    sum(BalanceDec02) as BalDec02,
    sum(BalanceJun03) as BalJun03,
    sum(BalanceSep03) as BalSep03,
    sum(BalanceDec03) as BalDec03,
    sum(BalanceMar04) as BalMar04 ,
    sum(BalanceJun04) as BalJun04,
    sum(BalanceSep04) as BalSep04,
    sum(BalanceDec04) as BalDec04
--from WebDeferredRev..OutstandingBalanceAsOf2004Jan1
into sum_JasonOutstandingBal
from JasonOutstandingBal 
go

--ALTER TABLE dbo.JasonOutstandingBal ADD dateLastPurchased datetime NULL
--go

--update JasonOutstandingBal 
--set a.dateLastPurchased = b.dateLastPurchased
--from JasonOutstandingBal  a (index idx_userId) , TempJasonPositiveChart  b (index idx_userId)
--where a.userId = b.userId

/*
--sep03
select   datepart(yy,dateLastPurChasedSep03) * 100 + datepart(mm,dateLastPurChasedSep03) as dateLastPurChasedSep03, 
    sum(BalanceSep03) as BalanceSep03,	
    sum(CASE WHEN dateLastPurchased >= "OCT 1 2003" THEN BalanceSep03 ELSE 0 END),			
    sum(CASE WHEN dateLastPurchased < "OCT 1 2003" THEN BalanceSep03 ELSE 0 END)			
from JasonOutstandingBal
group by datepart(yy,dateLastPurChasedSep03) * 100 + datepart(mm,dateLastPurChasedSep03)

--dec03
select   datepart(yy,dateLastPurChasedDec03) * 100 + datepart(mm,dateLastPurChasedDec03) as dateLastPurChasedDec03,
    sum(BalanceDec03) as BalanceDec03	,
    sum(CASE WHEN dateLastPurchased >= "jan 1 2004" THEN BalanceDec03 ELSE 0 END),			
    sum(CASE WHEN dateLastPurchased < "jan  1 2004" THEN BalanceDec03 ELSE 0 END)			
from JasonOutstandingBal
group by datepart(yy,dateLastPurChasedDec03) * 100 + datepart(mm,dateLastPurChasedDec03)

--Mar04
select   datepart(yy,dateLastPurChasedMar04) * 100 + datepart(mm,dateLastPurChasedMar04) as dateLastPurChasedMar04,
    sum(BalanceMar04) as BalanceMar04,
    sum(CASE WHEN dateLastPurchased >= "apr 1 2004" THEN BalanceMar04 ELSE 0 END),                      
    sum(CASE WHEN dateLastPurchased <  "apr 1 2004" THEN BalanceMar04 ELSE 0 END) 
from JasonOutstandingBal
group by datepart(yy,dateLastPurChasedMar04) * 100 + datepart(mm,dateLastPurChasedMar04)


--jun04
select   datepart(yy,dateLastPurChasedJun04) * 100 + datepart(mm,dateLastPurChasedJun04) as dateLastPurChasedJun04,
    sum(BalanceJun04) as BalanceJun04,
    sum(CASE WHEN dateLastPurchased >= "jul 1 2004" THEN BalanceJun04 ELSE 0 END),			
    sum(CASE WHEN dateLastPurchased <  "jul 1 2004" THEN BalanceJun04 ELSE 0 END)			
from JasonOutstandingBal
group by datepart(yy,dateLastPurChasedJun04) * 100 + datepart(mm,dateLastPurChasedJun04)

*/

