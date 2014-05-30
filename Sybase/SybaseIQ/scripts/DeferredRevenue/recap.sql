--===step 1: web outstanding balance as Oct 1 2003 (run under webdb0p's WebDeferredRev database)
SELECT 
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "oct 1 1999") THEN number_units ELSE 0 END) as BalanceSep99,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "oct 1 2000") THEN number_units ELSE 0 END) as BalanceSep00,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "oct 1 2001") THEN number_units ELSE 0 END) as BalanceSep01,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "jul 1 2002") THEN number_units ELSE 0 END) as BalanceJun02,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "oct 1 2002") THEN number_units ELSE 0 END) as BalanceSep02,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "jan 1 2003") THEN number_units ELSE 0 END) as BalanceDec02,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "jul 1 2003") THEN number_units ELSE 0 END) as BalanceJun03,
    SUM(CASE WHEN timestamp < datediff(ss, "jan 1 1970", "oct 1 2003") THEN number_units ELSE 0 END) as BalanceSep03
FROM account_request_WEB
WHERE token_type = "R" OR token_type = "a" -- "R" means purchase; "a" means consumption

-- RESULT:
--BalanceSep99	BalanceSep00	BalanceSep01	BalanceJun02	BalanceSep02	BalanceDec02	BalanceJun03	BalanceSep03
1921039	4452833	8216825	13332016	15044643	16790587	21775836	24215611

--without "a"
 BalanceSep99 BalanceSep00 BalanceSep01 BalanceJun02 BalanceSep02 BalanceDec02 BalanceJun03 BalanceSep03
 ------------ ------------ ------------ ------------ ------------ ------------ ------------ ------------
      1880649      4385185      8217051     13332242     15044869     16790813     21776062     24215837


--===step 2:  Due to Accounting Conversion on Nov 12 2003, (run under webdb0r's AccountRequest db and WebDeferredRev database)
SELECT SUM(number_units) FROM AccountRequest..account_request_hist 
WHERE token_type = "R" OR token_type = "a" -- "R" means purchase; "a" means consumption
    and timestamp < datediff(ss, "jan 1 1970", "jan 1 2004")
-- result: 3,574,975 credit 

SELECT userId, max(xactionId) as xactionId, 0 as creditBalance 
INTO WebDeferredRev..TEMP_STEP2_Balance
FROM arch_Accounting..AccountTransaction a (index XAK1AccountTransaction)
WHERE  
    ((a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId in (1,2,3,4,6)) --1,2,3,4 are consumption, 6 is purchase
    or a.xactionTypeId = 5) -- balance 
    and a.dateCreated < "jan 1 2004"
GROUP BY a.userId 

CREATE UNIQUE NONCLUSTERED INDEX idx_xactionId
    ON dbo.TEMP_STEP2_Balance(xactionId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TEMP_STEP2_Balance') AND name='idx_xactionId')
    PRINT '<<< CREATED INDEX dbo.TEMP_STEP2_Balance.idx_xactionId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TEMP_STEP2_Balance.idx_xactionId >>>'
go

UPDATE WebDeferredRev..TEMP_STEP2_Balance
SET A.creditBalance = B.balance 
FROM WebDeferredRev..TEMP_STEP2_Balance A, arch_Accounting..AccountTransaction B
WHERE A.xactionId = B.xactionId

select sum(creditBalance) from TEMP_STEP2_Balance
-- result: 14,612,651

--=====





