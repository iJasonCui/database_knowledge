1,886,122
4,456,803
7,734,026
12,372,802
13,947,597
15,578,185
20,369,925
22,700,027
24,624,997

use wp_report
go


IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountTransaction') AND name='XIE1Covering')
BEGIN
    DROP INDEX AccountTransaction.XIE1Covering
    IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountTransaction') AND name='XIE1Covering')
        PRINT '<<< FAILED DROPPING INDEX AccountTransaction.XIE1Covering >>>'
    ELSE
        PRINT '<<< DROPPED INDEX AccountTransaction.XIE1Covering >>>'
END
go
CREATE NONCLUSTERED INDEX XIE1Covering
    ON dbo.AccountTransaction(dateCreated,creditTypeId,xactionTypeId,credits,userId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.AccountTransaction') AND name='XIE1Covering')
    PRINT '<<< CREATED INDEX dbo.AccountTransaction.XIE1Covering >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.AccountTransaction.XIE1Covering >>>'
go


--step 2:  outstanding balance after converting all historical data from account_request and account_request_hist into AccountTransaction							
SELECT 
    userId,							
    SUM(CASE WHEN dateCreated < "oct 1 1999" THEN credits ELSE 0 END) as BalanceSep99,	
    SUM(CASE WHEN dateCreated < "oct 1 2000" THEN credits ELSE 0 END) as BalanceSep00,						
    SUM(CASE WHEN dateCreated < "oct 1 2001" THEN credits ELSE 0 END) as BalanceSep01,						
    SUM(CASE WHEN dateCreated < "jul 1 2002" THEN credits ELSE 0 END) as BalanceJun02,						
    SUM(CASE WHEN dateCreated < "oct 1 2002" THEN credits ELSE 0 END) as BalanceSep02,						
    SUM(CASE WHEN dateCreated < "jan 1 2003" THEN credits ELSE 0 END) as BalanceDec02,						
    SUM(CASE WHEN dateCreated < "jul 1 2003" THEN credits ELSE 0 END) as BalanceJun03,						
    SUM(CASE WHEN dateCreated < "oct 1 2003" THEN credits ELSE 0 END) as BalanceSep03,						
    SUM(CASE WHEN dateCreated < "jan 1 2004" THEN credits ELSE 0 END) as BalanceDec03,
    SUM(CASE WHEN dateCreated < "jul 1 2004" THEN credits ELSE 0 END) as BalanceJun04,
    SUM(CASE WHEN dateCreated < "oct 1 2004" THEN credits ELSE 0 END) as BalanceSep04,
    SUM(CASE WHEN dateCreated < "jan 1 2005" THEN credits ELSE 0 END) as BalanceDec04						
INTO wp_report..TempJason_OutstandingBal
FROM wp_report..AccountTransaction 							
WHERE creditTypeId = 1 -- regular credit 							
    and xactionTypeId in (1,2,3,4,6) --1,2,3,4 are consumption, 6 is purchase							
GROUP BY userId


--Banned User 
select user_id as userId, status 
into wp_report..TempJasonBannedUser
from Member..user_info where status is null or status in ('Y', 'V', 'S')

--create index 
CREATE UNIQUE NONCLUSTERED INDEX idx_userId ON dbo.TempJasonBannedUser(userId)
CREATE UNIQUE NONCLUSTERED INDEX idx_userId ON dbo.TempJason_OutstandingBal(userId)

--delete Banned User
delete from wp_report..TempJason_OutstandingBal
where userId in (select userId from wp_report..TempJasonBannedUser)
--13597 row(s) affected.

delete from wp_report..TempJason_OutstandingBal where BalanceDec04 > 500
--629 row(s) affected

select count(*) FROM temp_jason_OutstandingBal where userStatus is null or userStatus in ('Y', 'V', 'S') or BalanceDec03 > 500
--9513 rows

--delete FROM WebDeferredRev..temp_jason_OutstandingBal 
--where userStatus is null or userStatus in ('Y', 'V', 'S') --or BalanceDec03 > 500

--delete from WebDeferredRev..temp_jason_OutstandingBal  
--where userId not in (select userId from WebDeferredRev..temp_jason_PositiveChart) --13010
--delete from WebDeferredRev..temp_jason_PositiveChart 
--where userId not in (select userId from WebDeferredRev..temp_jason_OutstandingBal  ) --1233

--769282 match userId


select     sum(BalanceSep99),
    sum(BalanceSep00) ,
    sum(BalanceSep01) ,
    sum(BalanceJun02) ,
    sum(BalanceSep02) ,
    sum(BalanceDec02) ,
    sum(BalanceJun03) ,
    sum(BalanceSep03) ,
    sum(BalanceDec03) ,
    sum(BalanceJun04) ,
    sum(BalanceSep04) ,
    sum(BalanceDec04)
from wp_report..JasonOutstandingBal
--from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 
--1886122	4456803	7734026	12372802	13947597	15578185	20369925	22700027	24624997
											
--1891545	4482757	7789298	12433656	14011266	15643565	20439954	22761880	24679901	28313970	30410052	32288238

--age by lastPurchaseDate as of reporting cut off time
SELECT
    userId,
    MAX(CASE WHEN dateCreated < "oct 1 1999" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep99,
    MAX(CASE WHEN dateCreated < "oct 1 2000" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep00,
    MAX(CASE WHEN dateCreated < "oct 1 2001" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep01,
    MAX(CASE WHEN dateCreated < "jul 1 2002" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun02,
    MAX(CASE WHEN dateCreated < "oct 1 2002" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep02,
    MAX(CASE WHEN dateCreated < "jan 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec02,
    MAX(CASE WHEN dateCreated < "jul 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun03,
    MAX(CASE WHEN dateCreated < "oct 1 2003" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep03,
    MAX(CASE WHEN dateCreated < "jan 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec03,
    MAX(CASE WHEN dateCreated < "jul 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedJun04,
    MAX(CASE WHEN dateCreated < "oct 1 2004" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedSep04,
    MAX(CASE WHEN dateCreated < "jan 1 2005" THEN dateCreated ELSE 'jan 1 1970' END) as dateLastPurChasedDec04
INTO wp_report..TempJasonOutstandingBalAge
FROM wp_report..AccountTransaction
WHERE creditTypeId = 1 -- regular credit
    and xactionTypeId = 6 --1,2,3,4 are conMAXption, 6 is purchase
GROUP BY userId

--delete banned user
delete from wp_report..TempJasonOutstandingBalAge
where userId in (select userId from wp_report..TempJasonBannedUser)
--13596 row(s) affected.

alter table wp_report..TempJason_OutstandingBal add
    dateLastPurChasedSep99 datetime      NULL,
    dateLastPurChasedSep00 datetime      NULL,
    dateLastPurChasedSep01 datetime      NULL,
    dateLastPurChasedJun02 datetime      NULL,
    dateLastPurChasedSep02 datetime      NULL,
    dateLastPurChasedDec02 datetime      NULL,
    dateLastPurChasedJun03 datetime      NULL,
    dateLastPurChasedSep03 datetime      NULL,
    dateLastPurChasedDec03 datetime      NULL,
    dateLastPurChasedJun04 datetime      NULL,
    dateLastPurChasedSep04 datetime      NULL,
    dateLastPurChasedDec04 datetime      NULL

update wp_report..TempJason_OutstandingBal 
set a.dateLastPurChasedSep99 = b.dateLastPurChasedSep99,
    a.dateLastPurChasedSep00 = b.dateLastPurChasedSep00,
    a.dateLastPurChasedSep01 = b.dateLastPurChasedSep01,
    a.dateLastPurChasedJun02 = b.dateLastPurChasedJun02,
    a.dateLastPurChasedSep02 = b.dateLastPurChasedSep02,
    a.dateLastPurChasedDec02 = b.dateLastPurChasedDec02,
    a.dateLastPurChasedJun03 = b.dateLastPurChasedJun03,
    a.dateLastPurChasedSep03 = b.dateLastPurChasedSep03,
    a.dateLastPurChasedDec03 = b.dateLastPurChasedDec03,
    a.dateLastPurChasedJun04 = b.dateLastPurChasedJun04,
    a.dateLastPurChasedSep04 = b.dateLastPurChasedSep04,
    a.dateLastPurChasedDec04 = b.dateLastPurChasedDec04
FROM wp_report..TempJason_OutstandingBal a (index idx_userId), 
     wp_report..TempJasonOutstandingBalAge b (index idx_userId)
where a.userId = b.userId 


select   datepart(yy,dateLastPurChasedSep99) * 100 + datepart(mm,dateLastPurChasedSep99),   sum(BalanceSep99)
from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 			
group by datepart(yy,dateLastPurChasedSep99) * 100 + datepart(mm,dateLastPurChasedSep99)

select count(*)
from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 a (index idx_userId), temp_jason_OutstandingBal_age b (index idx_userId)
where a.userId = b.userId 
--769188 rows effected

--dec2003
select   datepart(yy,b.dateLastPurChasedDec03) * 100 + datepart(mm,b.dateLastPurChasedDec03) as lastPurchaseYearMonth,   sum(a.BalanceDec03) as creditBalance
from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 a (index idx_userId), temp_jason_OutstandingBal_age b (index idx_userId)
where a.userId = b.userId 
group by datepart(yy,b.dateLastPurChasedDec03) * 100 + datepart(mm,b.dateLastPurChasedDec03)
go

--sep03
select   datepart(yy,b.dateLastPurChasedSep03) * 100 + datepart(mm,b.dateLastPurChasedSep03) as lastPurchaseYearMonth,   sum(a.BalanceSep03) as creditBalance
from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 a (index idx_userId), temp_jason_OutstandingBal_age b (index idx_userId)
where a.userId = b.userId 
group by datepart(yy,b.dateLastPurChasedSep03) * 100 + datepart(mm,b.dateLastPurChasedSep03)
go



--sep99
select   datepart(yy,b.dateLastPurChasedSep99) * 100 + datepart(mm,b.dateLastPurChasedSep99) as lastPurchaseYearMonth,   sum(a.BalanceSep99) as creditBalance
from WebDeferredRev..OutstandingBalanceAsOf2004Jan1 a (index idx_userId), temp_jason_OutstandingBal_age b (index idx_userId)
where a.userId = b.userId 
group by datepart(yy,b.dateLastPurChasedSep99) * 100 + datepart(mm,b.dateLastPurChasedSep99)
go

--sep00



