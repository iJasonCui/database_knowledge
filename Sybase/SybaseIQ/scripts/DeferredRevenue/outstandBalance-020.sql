select getdate()
go

IF OBJECT_ID('DeferredRev.JasonOutstandingBal') IS NOT NULL
BEGIN
   DROP TABLE DeferredRev.JasonOutstandingBal
END
ELSE BEGIN
   PRINT "THERE IS NO DeferredRev.JasonOutstandingBal"
END
go

CREATE TABLE DeferredRev.JasonOutstandingBal
(
    userId                 numeric(12,0) NOT NULL,
    BalanceSep99           int           NULL,
    BalanceSep00           int           NULL,
    BalanceSep01           int           NULL,
    BalanceJun02           int           NULL,
    BalanceSep02           int           NULL,
    BalanceDec02           int           NULL,
    BalanceJun03           int           NULL,
    BalanceSep03           int           NULL,
    BalanceDec03           int           NULL,   
    BalanceMar04           int           NULL, 
    BalanceJun04           int           NULL,
    BalanceSep04           int           NULL,
    BalanceDec04           int           NULL,
    BalanceMar05           int           NULL,
    BalanceJun05           int           NULL
)
go
 
INSERT DeferredRev.JasonOutstandingBal
(
    userId      ,
    BalanceSep99,
    BalanceSep00,
    BalanceSep01,
    BalanceJun02,
    BalanceSep02,
    BalanceDec02,
    BalanceJun03,
    BalanceSep03,
    BalanceDec03,
    BalanceMar04,
    BalanceJun04,
    BalanceSep04,
    BalanceDec04,
    BalanceMar05,
    BalanceJun05
)
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
    SUM(CASE WHEN dateCreated < "apr 1 2004" THEN credits ELSE 0 END) as BalanceMar04,
    SUM(CASE WHEN dateCreated < "jul 1 2004" THEN credits ELSE 0 END) as BalanceJun04,
    SUM(CASE WHEN dateCreated < "oct 1 2004" THEN credits ELSE 0 END) as BalanceSep04,
    SUM(CASE WHEN dateCreated < "jan 1 2005" THEN credits ELSE 0 END) as BalanceDec04,                                           
    SUM(CASE WHEN dateCreated < "apr 1 2005" THEN credits ELSE 0 END) as BalanceMar05,
    SUM(CASE WHEN dateCreated < "jul 1 2005" THEN credits ELSE 0 END) as BalanceJun05
FROM DeferredRev.AccountTransaction                                                      
WHERE creditTypeId = 1 -- regular credit                                                        
    and xactionTypeId in (1,2,3,4,6,21,22,23,24,25,26,28) -- 1-4,21-26,28 are consumption, 6 is purchase    
GROUP BY userId
go

CREATE UNIQUE NONCLUSTERED INDEX idx_userId ON dbo.DeferredRev.JasonOutstandingBal(userId)
go

select getdate()
go

/*
ctionTypeId   description
1       IM BASIC
2       IM DOUBLE
3       MAIL
4       COLLECT MAIL
5       balance
6       purchase
7       declined
8       charge back
9       credit (reversal)
10      void (same-day reversal)
11      expiry
12      admin adjustment
13      downtime compensation
14      USI promo
15      admin compensation
16      VIDEO MAIL
17      COLLECT VIDEO MAIL
18      processor refused
19      processor cancelled
20      processor charged back
21      IM extended session 1 minute fro
22      IM extended session 2 minutes fr
23      IM extended session 5 minutes fr
24      IM extended session 1 minute fro
25      IM extended session 2 minutes fr
26      IM extended session 5 minutes fr
28      PARTY 20 minutes IM session
29      UK Free Trial
30      Subscription Promo
31      Subscription Purchase
32      Subscription Renewal
*/

