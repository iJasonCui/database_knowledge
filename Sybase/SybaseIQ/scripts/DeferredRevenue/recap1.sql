--All customer who did purchase between Sep 1 2003 and Feb 1 2004
--drop table WebDeferredRev..temp_jason_customerList30

SELECT p.userId as customerId,
    Max(p.dateCreated) as dateLastPurchased,
    Min(p.dateCreated) as dateFirstPurchased,
    convert(numeric(10,2),0) as purchaseAmountLast, 
    convert(numeric(10,2),0) as purchaseAmountTotal,
    0 as creditLastPurchased,     
    0 as creditTotalPurchased,     
   0 as creditConsumedD30,
   0 as creditConsumedD60,
   0 as creditConsumedD90,
   0 as creditConsumedD120,
   0 as creditConsumedD150,
   0 as creditConsumedD180,
   0 as creditConsumedD210,
   0 as creditConsumedD30First,
   0 as creditConsumedD60First,
   0 as creditConsumedD90First,
   0 as creditConsumedD120First,
   0 as creditConsumedD150First,
   0 as creditConsumedD180First,
   0 as creditConsumedD210First
INTO WebDeferredRev..temp_jason_customerList30
FROM arch_Accounting..Purchase p
WHERE p.dateCreated >= "jun 1 2003" and p.dateCreated < "sep 1 2003" and p.xactionTypeId = 6  
GROUP BY userId

--create index 
CREATE UNIQUE NONCLUSTERED INDEX idx_userId
    ON dbo.temp_jason_customerList30(customerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_jason_customerList30') AND name='idx_userId')
    PRINT '<<< CREATED INDEX dbo.temp_jason_customerList30.idx_userId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.temp_jason_customerList30.idx_userId >>>'
go


--update purchaseAmountLast based on userId and last dateCreated
UPDATE WebDeferredRev..temp_jason_customerList30
SET u.purchaseAmountLast = convert(numeric(10,2), p.costUSD + p.taxUSD), 
    u.creditLastPurchased = po.credits
FROM WebDeferredRev..temp_jason_customerList30 u, arch_Accounting..Purchase p,  arch_Accounting..PurchaseOfferDetail po  
WHERE u.customerId = p.userId and u.dateLastPurchased = p.dateCreated and p.purchaseOfferDetailId = po.purchaseOfferDetailId  

--update credit consumed info
--DROP TABLE WebDeferredRev..temp_jason_creditConsumed30

SELECT a.userId as customerId,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,31,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD30,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,31, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,61,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD60,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,61, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,91,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD90,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,91, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,121,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD120,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,121, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,151,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD150,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,151, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,181,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD180,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,181, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,211,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD210,

    SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,31,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD30First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,31, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,61,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD60First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,61, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,91,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD90First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,91, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,121,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD120First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,121, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,151,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD150First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,151, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,181,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD180First,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,181, c.dateFirstPurchased)  and a.dateCreated < dateadd(dd,211,c.dateFirstPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD210First
INTO WebDeferredRev..temp_jason_creditConsumed30
FROM WebDeferredRev..temp_jason_customerList30 c, arch_Accounting..AccountTransaction a (index XCON1AccountTransaction)
WHERE  a.userId  = c.customerId 
    and a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId >= 1 and a.xactionTypeId <= 4 --consumption
--    and a.userId = 163558241 and c.customerId = 163558241
    and a.dateCreated >= "jun 1 2003" and a.dateCreated < "sep 1 2003"
GROUP BY a.userId 

--================== unique index on userId
CREATE UNIQUE NONCLUSTERED INDEX idx_userId
    ON dbo.temp_jason_creditConsumed30(customerId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.temp_jason_creditConsumed30') AND name='idx_userId')
    PRINT '<<< CREATED INDEX dbo.temp_jason_creditConsumed30.idx_userId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.temp_jason_creditConsumed30.idx_userId >>>'
go

--=============update credit consumed ===========
update WebDeferredRev..temp_jason_customerList30
set 
    c.creditConsumedD30 = a.creditConsumedD30,
    c.creditConsumedD60 = a.creditConsumedD60,
    c.creditConsumedD90 = a.creditConsumedD90,
    c.creditConsumedD120 = a.creditConsumedD120,
    c.creditConsumedD150 = a.creditConsumedD150,
    c.creditConsumedD180 = a.creditConsumedD180
FROM WebDeferredRev..temp_jason_customerList30 c, WebDeferredRev..temp_jason_creditConsumed30 a
WHERE  a.customerId = c.customerId 

select --lastTranYearMonth,
    sum(purchaseAmountLast) as purchaseLast,
    SUM(creditLastPurchased) AS credits,    
    SUM(creditConsumedD30) AS D30,
    SUM(creditConsumedD60) AS D60,
    SUM(creditConsumedD90) AS D90,
    SUM(creditConsumedD120) AS D120,
    SUM(creditConsumedD150) AS D150,
    SUM(creditConsumedD180) AS D180
FROM WebDeferredRev..temp_jason_customerList30 --where lastTranYearMonth = 200309
GROUP BY lastTranYearMonth

select --lastTranYearMonth,
    AVG(creditLastPurchased) AS credits,    
    AVG(creditConsumedD1) AS D1,
    AVG(creditConsumedD2) AS D2,
    AVG(creditConsumedD3) AS D3,
    AVG(creditConsumedD4) AS D4,
    AVG(creditConsumedD5) AS D5,
    AVG(creditConsumedD6) AS D6,
    AVG(creditConsumedD7) AS D7,
    AVG(creditConsumedD8) AS D8,
    AVG(creditConsumedD9) AS D9,
    AVG(creditConsumedD10) AS D10,
    AVG(creditConsumedD11) AS D11,
    AVG(creditConsumedD12) AS D12,
    AVG(creditConsumedD13) AS D13,
    AVG(creditConsumedD14) AS D14,
    AVG(creditConsumedD15) AS D15,
    AVG(creditConsumedD16) AS D16,
    AVG(creditConsumedD17) AS D17,
    AVG(creditConsumedD18) AS D18,
    AVG(creditConsumedD19) AS D19,
    AVG(creditConsumedD20) AS D20,
    AVG(creditConsumedD21) AS D21,
    AVG(creditConsumedD22) AS D22,
    AVG(creditConsumedD23) AS D23,
    AVG(creditConsumedD24) AS D24,
    AVG(creditConsumedD25) AS D25,
    AVG(creditConsumedD26) AS D26,
    AVG(creditConsumedD27) AS D27,
    AVG(creditConsumedD28) AS D28,
    AVG(creditConsumedD29) AS D29,
    AVG(creditConsumedD30) AS D30,
    AVG(creditConsumedD31) AS D31,
    AVG(creditConsumedD32) AS D32,
    AVG(creditConsumedD33) AS D33,
    AVG(creditConsumedD34) AS D34,
    AVG(creditConsumedD35) AS D35,
    AVG(creditConsumedD36) AS D36,
    AVG(creditConsumedD37) AS D37,
    AVG(creditConsumedD38) AS D38,
    AVG(creditConsumedD39) AS D39,
    AVG(creditConsumedD40) AS D40,
    AVG(creditConsumedD41) AS D41,
    AVG(creditConsumedD42) AS D42,
    AVG(creditConsumedD43) AS D43,
    AVG(creditConsumedD44) AS D44,
    AVG(creditConsumedD45) AS D45,
    AVG(creditConsumedD46) AS D46,
    AVG(creditConsumedD47) AS D47,
    AVG(creditConsumedD48) AS D48,
    AVG(creditConsumedD49) AS D49,
    AVG(creditConsumedD50) AS D50,
    AVG(creditConsumedD51) AS D51,
    AVG(creditConsumedD52) AS D52,
    AVG(creditConsumedD53) AS D53,
    AVG(creditConsumedD54) AS D54,
    AVG(creditConsumedD55) AS D55,
    AVG(creditConsumedD56) AS D56,
    AVG(creditConsumedD57) AS D57,
    AVG(creditConsumedD58) AS D58,
    AVG(creditConsumedD59) AS D59,
    AVG(creditConsumedD60) AS D60,
    AVG(creditConsumedD61) AS D61,
    AVG(creditConsumedD62) AS D62,
    AVG(creditConsumedD63) AS D63,
    AVG(creditConsumedD64) AS D64,
    AVG(creditConsumedD65) AS D65,
    AVG(creditConsumedD66) AS D66,
    AVG(creditConsumedD67) AS D67,
    AVG(creditConsumedD68) AS D68,
    AVG(creditConsumedD69) AS D69,
    AVG(creditConsumedD70) AS D70,
    AVG(creditConsumedD71) AS D71,
    AVG(creditConsumedD72) AS D72,
    AVG(creditConsumedD73) AS D73,
    AVG(creditConsumedD74) AS D74,
    AVG(creditConsumedD75) AS D75,
    AVG(creditConsumedD76) AS D76,
    AVG(creditConsumedD77) AS D77,
    AVG(creditConsumedD78) AS D78,
    AVG(creditConsumedD79) AS D79,
    AVG(creditConsumedD80) AS D80,
    AVG(creditConsumedD81) AS D81,
    AVG(creditConsumedD82) AS D82,
    AVG(creditConsumedD83) AS D83,
    AVG(creditConsumedD84) AS D84,
    AVG(creditConsumedD85) AS D85,
    AVG(creditConsumedD86) AS D86,
    AVG(creditConsumedD87) AS D87,
    AVG(creditConsumedD88) AS D88,
    AVG(creditConsumedD89) AS D89,
    AVG(creditConsumedD90) AS D90,
    AVG(creditConsumedD91) AS D91,
    AVG(creditConsumedD92) AS D92,
    AVG(creditConsumedD93) AS D93,
    AVG(creditConsumedD94) AS D94,
    AVG(creditConsumedD95) AS D95,
    AVG(creditConsumedD96) AS D96,
    AVG(creditConsumedD97) AS D97,
    AVG(creditConsumedD98) AS D98,
    AVG(creditConsumedD99) AS D99,
    AVG(creditConsumedD100) AS D100,
    AVG(creditConsumedD101) AS D101,
    AVG(creditConsumedD102) AS D102,
    AVG(creditConsumedD103) AS D103,
    AVG(creditConsumedD104) AS D104,
    AVG(creditConsumedD105) AS D105,
    AVG(creditConsumedD106) AS D106,
    AVG(creditConsumedD107) AS D107,
    AVG(creditConsumedD108) AS D108,
    AVG(creditConsumedD109) AS D109,
    AVG(creditConsumedD110) AS D110,
    AVG(creditConsumedD111) AS D111,
    AVG(creditConsumedD112) AS D112,
    AVG(creditConsumedD113) AS D113,
    AVG(creditConsumedD114) AS D114,
    AVG(creditConsumedD115) AS D115,
    AVG(creditConsumedD116) AS D116,
    AVG(creditConsumedD117) AS D117,
    AVG(creditConsumedD118) AS D118,
    AVG(creditConsumedD119) AS D119,
    AVG(creditConsumedD120) AS D120,
    AVG(creditConsumedD121) AS D121,
    AVG(creditConsumedD122) AS D122,
    AVG(creditConsumedD123) AS D123,
    AVG(creditConsumedD124) AS D124,
    AVG(creditConsumedD125) AS D125,
    AVG(creditConsumedD126) AS D126,
    AVG(creditConsumedD127) AS D127,
    AVG(creditConsumedD128) AS D128,
    AVG(creditConsumedD129) AS D129,
    AVG(creditConsumedD130) AS D130,
    AVG(creditConsumedD131) AS D131,
    AVG(creditConsumedD132) AS D132,
    AVG(creditConsumedD133) AS D133,
    AVG(creditConsumedD134) AS D134,
    AVG(creditConsumedD135) AS D135,
    AVG(creditConsumedD136) AS D136,
    AVG(creditConsumedD137) AS D137,
    AVG(creditConsumedD138) AS D138,
    AVG(creditConsumedD139) AS D139,
    AVG(creditConsumedD140) AS D140,
    AVG(creditConsumedD141) AS D141,
    AVG(creditConsumedD142) AS D142,
    AVG(creditConsumedD143) AS D143,
    AVG(creditConsumedD144) AS D144,
    AVG(creditConsumedD145) AS D145,
    AVG(creditConsumedD146) AS D146,
    AVG(creditConsumedD147) AS D147,
    AVG(creditConsumedD148) AS D148,
    AVG(creditConsumedD149) AS D149,
    AVG(creditConsumedD150) AS D150
--FROM WebDeferredRev..temp_jason_customerList
FROM WebDeferredRev..temp_jason_customer200309 


SELECT * INTO WebDeferredRev..temp_jason_customer200309
FROM WebDeferredRev..temp_jason_customerList
where lastTranYearMonth = 200309 

select * 
FROM WebDeferredRev..temp_jason_customerList
WHERE customerId = 163558241
--customerId	lastTranYearMonth	dateLastPurchased	purchaseAmountLast	creditLastPurchased	creditConsumedM30	creditConsumedM60	creditConsumedM90	creditConsumedM120	creditConsumedM150
163558241	200401	1/30/2004 12:34:25.217 PM	39.99	200	0	0	0	0	0

select userId, abs(sum(credits))
from arch_Accounting..AccountTransaction 
where dateCreated >= "jan 30 2004 12:34 PM" and dateCreated < "feb 1 2004" 
    and userId = 163558241 
    and creditTypeId = 1 -- regular credit 
    and xactionTypeId >= 1 and xactionTypeId <= 4 --consumption
group by userId



set rowcount 100
select * from WebDeferredRev..temp_jason_customerList

--web deferred revenue 
select count(*) from WebDeferredRev..temp_account_request  where lastTranYearMonth >= 200309 and lastTranYearMonth <= 200401
--  178892 rows 

--ad hoc report 
select count(*) from WebDeferredRev..temp_jason_customerList
--  178892 rows 

set rowcount 100
select * from WebDeferredRev..temp_jason_Purchase where customerId = 163558241 -- order by unitQty desc
--customerId	unitQty	totalPrice	firstTranYearMonth	lastTranYearMonth
--163558241	10000	1999.50	200309	200401

select * from arch_Accounting..Purchase
where dateCreated >= "sep 1 2003" and dateCreated < "feb 1 2004" and userId = 163558241

select distinct creditTypeId , xactionTypeId , contentId
from arch_Accounting..AccountTransaction 
where dateCreated >= "sep 1 2003" and dateCreated < "feb 1 2004" 
    and userId = 163558241 

    and creditTypeId = 1 -- regular credit 
    and xactionTypeId >= 1 and xactionTypeId <= 4 --consumption


select userId, 100 * datepart(yy,dateCreated) + datepart(mm,dateCreated) as ConsumYearMonth, sum(credits)
from arch_Accounting..AccountTransaction 
where dateCreated >= "sep 1 2003" and dateCreated < "feb 1 2004" 
    and userId = 163558241 
    and creditTypeId = 1 -- regular credit 
    and xactionTypeId >= 1 and xactionTypeId <= 4 --consumption
group by userId, 100 * datepart(yy,dateCreated) + datepart(mm,dateCreated) 


select * from Member..user_info where user_id = 163558241
select * from Profile_ad..a_profile_dating where user_id = 163558241
select * from Profile_ar..a_profile_romance where user_id = 163558241
select * from Profile_ai..a_profile_intimate where user_id = 163558241

SELECT a.* , b.* FROM CreditType a, Content b where a.contentId = b.contentId 
--creditTypeId	contentId	ordinal	duration	contentId	contentDesc
1	8	0	0	8	Regular Credit
2	9	1	0	9	Promotional Credit
3	10	1	0	10	Free Credit
4	11	1	0	11	Admin Credit
5	12	1	0	12	Downtime Credit
6	13	2	30	13	Banner Promo Credit
7	14	2	30	14	MP3 Promo Credit
8	57	2	30	57	Reactivation promo
9	60	2	13	60	ICQ Promo


SELECT * FROM dbo.XactionType
--xactionTypeId	description
1	IM BASIC
2	IM DOUBLE
3	MAIL
4	COLLECT MAIL
5	balance
6	purchase
7	declined
8	charge back
9	credit (reversal)
10	void (same-day reversal)
11	expiry
12	admin adjustment
13	downtime compensation
14	USI promo
15	admin compensation
16	VIDEO MAIL
17	COLLECT VIDEO MAIL

select * from arch_Accounting..PurchaseOfferDetail 

SELECT * FROM Content 
--==contentId	contentDesc
1	Fun & Flirt
2	Mix & Mingle
3	Click & Connect
4	20 Minute IM session
5	60 Minute IM session
6	Mail
7	Collect Mail
8	Regular Credit
9	Promotional Credit
10	Free Credit
11	Admin Credit
12	Downtime Credit
13	Banner Promo Credit
14	MP3 Promo Credit
15	Account Balance
16	Declined
17	Purchase
18	Adjustment
19	Account Balance
20	Money Order
21	Certified Cheque
22	900 Purchase
23	Credit Purchase
24	Ticket Purchase
25	Customer declined charge
26	Removing Temporary Credits
27	Basic Credit Package Purchase
28	Value Credit Package Purchase
29	Double Value Credit Package Purchase
30	Extra Value Credit Package Purchase
31	Visa nickname
32	MasterCard nickname
33	Amex nickname
34	Visa
35	MasterCard
36	Amex
37	Admin credits - Site Maintenance
38	Admin credits - Scammed
39	Admin credits - Solicitation
40	Admin credits - Lavalife Employee
41	Admin credits - Promotion
42	Admin credits - Courtesy
43	Admin credits - Other
44	Too many credit cards entered within one day.
45	Country on credit card different from member country.
46	Too many credit cards.
47	Too many purchases within one day.
48	Too many purchase attempts within one day.
49	Admin reversal - Double billed
50	Admin reversal - Cannot use site
51	Admin reversal - Refund
52	Admin reversal - Wrong account
53	Admin reversal - Administrative error
54	Admin reversal - Other
55	Bad Card - charge back
56	Bad Card - member banned
57	Reactivation promo
58	Video Mail
59	Collect Video Mail
60	ICQ Promo

--==================== code for gen code

set nocount on
declare @counter int
DECLARE @return_result varchar(250)
select @counter = 1

while @counter <= 150 
begin
    select @return_result = "   0 as creditConsumedD" + convert(varchar(10),@counter) + ","
    print @return_result
    select @counter = @counter + 1
end

--===========================
--    SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateLastPurchased) and a.dateCreated < dateadd(dd,1,c.dateLastPurchased) THEN a.credits ELSE 0 END) AS creditConsumedD1,
set nocount on
declare @counter int
DECLARE @return_result varchar(250)
select @counter = 1

while @counter <= 150 
begin
    select @return_result = "    SUM(CASE WHEN a.dateCreated >= dateadd(dd," + convert(varchar(10),@counter-1) + ", c.dateLastPurchased) "
        + " and a.dateCreated < dateadd(dd," + convert(varchar(10),@counter) + ",c.dateLastPurchased) " 
        + " THEN a.credits ELSE 0 END) AS creditConsumedD" + convert(varchar(10),@counter) + ","
    print @return_result
    select @counter = @counter + 1
end

--=========================
--  c.creditConsumedM30 = a.creditConsumedM30,

set nocount on
declare @counter int
DECLARE @return_result varchar(250)
select @counter = 1

while @counter <= 150 
begin
    select @return_result = "    c.creditConsumedD" + convert(varchar(10),@counter) + " = a.creditConsumedD" + convert(varchar(10),@counter) + ","
    print @return_result
    select @counter = @counter + 1
end

--===================    SUM(creditConsumedM30) as D30,
set nocount on
declare @counter int
DECLARE @return_result varchar(250)
select @counter = 1

while @counter <= 150 
begin
    select @return_result = "    SUM(creditConsumedD" + convert(varchar(10),@counter) + ") AS D" + convert(varchar(10),@counter) + ","
    print @return_result
    select @counter = @counter + 1
end

--=============== AVG ==
set nocount on
declare @counter int
DECLARE @return_result varchar(250)
select @counter = 1

while @counter <= 150 
begin
    select @return_result = "    AVG(creditConsumedD" + convert(varchar(10),@counter) + ") AS D" + convert(varchar(10),@counter) + ","
    print @return_result
    select @counter = @counter + 1
end



