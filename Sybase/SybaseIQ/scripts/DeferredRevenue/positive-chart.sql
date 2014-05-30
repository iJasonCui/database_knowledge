select count(*) from user_info 
where user_type = 'P' and status not in ("Y", "V", "S")
---653,714

select count(*) from user_info_hist
where user_type = 'P' and status not in ("Y", "V", "S")
--151,827


Y-- UNDER AGE
V-- BANNED
S-- SUSPENDED



--All customer who did purchase before Feb 1 2004
--drop table wp_report..TempJasonPositiveChart

SELECT userId,
--   NULL as userStatus,
   Max(dateCreated) as dateLastPurchased,
   0 as initialBalance,
   0 as creditLastPurchased,     
   0 as creditConsumedD1,
   0 as creditConsumedD2,
   0 as creditConsumedD3,
   0 as creditConsumedD4,
   0 as creditConsumedD5,
   0 as creditConsumedD6,
   0 as creditConsumedD7,
   0 as creditConsumedD8,
   0 as creditConsumedD9,
   0 as creditConsumedD10,
   0 as creditConsumedD11,
   0 as creditConsumedD12,
   0 as creditConsumedD13,
   0 as creditConsumedD14,
   0 as creditConsumedD15,
   0 as creditConsumedD16,
   0 as creditConsumedD17,
   0 as creditConsumedD18,
   0 as creditConsumedD19,
   0 as creditConsumedD20,
   0 as creditConsumedD21,
   0 as creditConsumedD22,
   0 as creditConsumedD23,
   0 as creditConsumedD24,
   0 as creditConsumedD25,
   0 as creditConsumedD26,
   0 as creditConsumedD27,
   0 as creditConsumedD28,
   0 as creditConsumedD29,
   0 as creditConsumedD30,
   0 as creditConsumedD31,
   0 as creditConsumedD32,
   0 as creditConsumedD33,
   0 as creditConsumedD34,
   0 as creditConsumedD35,
   0 as creditConsumedD36,
   0 as creditConsumedD37,
   0 as creditConsumedD38,
   0 as creditConsumedD39,
   0 as creditConsumedD40,
   0 as creditConsumedD41,
   0 as creditConsumedD42,
   0 as creditConsumedD43,
   0 as creditConsumedD44,
   0 as creditConsumedD45,
   0 as creditConsumedD46,
   0 as creditConsumedD47,
   0 as creditConsumedD48,
   0 as creditConsumedD49,
   0 as creditConsumedD50,
   0 as creditConsumedD51,
   0 as creditConsumedD52,
   0 as creditConsumedD53,
   0 as creditConsumedD54,
   0 as creditConsumedD55,
   0 as creditConsumedD56,
   0 as creditConsumedD57,
   0 as creditConsumedD58,
   0 as creditConsumedD59,
   0 as creditConsumedD60,
   0 as creditConsumedD61,
   0 as creditConsumedD62,
   0 as creditConsumedD63,
   0 as creditConsumedD64,
   0 as creditConsumedD65,
   0 as creditConsumedD66,
   0 as creditConsumedD67,
   0 as creditConsumedD68,
   0 as creditConsumedD69,
   0 as creditConsumedD70,
   0 as creditConsumedD71,
   0 as creditConsumedD72,
   0 as creditConsumedD73,
   0 as creditConsumedD74,
   0 as creditConsumedD75,
   0 as creditConsumedD76,
   0 as creditConsumedD77,
   0 as creditConsumedD78,
   0 as creditConsumedD79,
   0 as creditConsumedD80,
   0 as creditConsumedD81,
   0 as creditConsumedD82,
   0 as creditConsumedD83,
   0 as creditConsumedD84,
   0 as creditConsumedD85,
   0 as creditConsumedD86,
   0 as creditConsumedD87,
   0 as creditConsumedD88,
   0 as creditConsumedD89,
   0 as creditConsumedD90,
   0 as creditConsumedD91,
   0 as creditConsumedD92,
   0 as creditConsumedD93,
   0 as creditConsumedD94,
   0 as creditConsumedD95,
   0 as creditConsumedD96,
   0 as creditConsumedD97,
   0 as creditConsumedD98,
   0 as creditConsumedD99,
   0 as creditConsumedD100,
   0 as creditConsumedD101,
   0 as creditConsumedD102,
   0 as creditConsumedD103,
   0 as creditConsumedD104,
   0 as creditConsumedD105,
   0 as creditConsumedD106,
   0 as creditConsumedD107,
   0 as creditConsumedD108,
   0 as creditConsumedD109,
   0 as creditConsumedD110,
   0 as creditConsumedD111,
   0 as creditConsumedD112,
   0 as creditConsumedD113,
   0 as creditConsumedD114,
   0 as creditConsumedD115,
   0 as creditConsumedD116,
   0 as creditConsumedD117,
   0 as creditConsumedD118,
   0 as creditConsumedD119,
   0 as creditConsumedD120,
   0 as creditConsumedD121,
   0 as creditConsumedD122,
   0 as creditConsumedD123,
   0 as creditConsumedD124,
   0 as creditConsumedD125,
   0 as creditConsumedD126,
   0 as creditConsumedD127,
   0 as creditConsumedD128,
   0 as creditConsumedD129,
   0 as creditConsumedD130,
   0 as creditConsumedD131,
   0 as creditConsumedD132,
   0 as creditConsumedD133,
   0 as creditConsumedD134,
   0 as creditConsumedD135,
   0 as creditConsumedD136,
   0 as creditConsumedD137,
   0 as creditConsumedD138,
   0 as creditConsumedD139,
   0 as creditConsumedD140,
   0 as creditConsumedD141,
   0 as creditConsumedD142,
   0 as creditConsumedD143,
   0 as creditConsumedD144,
   0 as creditConsumedD145,
   0 as creditConsumedD146,
   0 as creditConsumedD147,
   0 as creditConsumedD148,
   0 as creditConsumedD149,
   0 as creditConsumedD150,
   0 as creditConsumedD151,
   0 as creditConsumedD152,
   0 as creditConsumedD153,
   0 as creditConsumedD154,
   0 as creditConsumedD155,
   0 as creditConsumedD156,
   0 as creditConsumedD157,
   0 as creditConsumedD158,
   0 as creditConsumedD159,
   0 as creditConsumedD160,
   0 as creditConsumedD161,
   0 as creditConsumedD162,
   0 as creditConsumedD163,
   0 as creditConsumedD164,
   0 as creditConsumedD165,
   0 as creditConsumedD166,
   0 as creditConsumedD167,
   0 as creditConsumedD168,
   0 as creditConsumedD169,
   0 as creditConsumedD170,
   0 as creditConsumedD171,
   0 as creditConsumedD172,
   0 as creditConsumedD173,
   0 as creditConsumedD174,
   0 as creditConsumedD175,
   0 as creditConsumedD176,
   0 as creditConsumedD177,
   0 as creditConsumedD178,
   0 as creditConsumedD179,
   0 as creditConsumedD180
INTO wp_report..TempJasonPositiveChart
FROM wp_report..AccountTransaction p (INDEX idx_covering)
WHERE p.dateCreated < "feb 1 2004" and p.xactionTypeId = 6 
GROUP BY p.userId
--update purchaseAmountLast based on userId and last dateCreated
UPDATE wp_report..TempJasonPositiveChart
SET u.creditLastPurchased = p.credits
FROM wp_report..TempJasonPositiveChart u (INDEX idx_userId), wp_report..AccountTransaction p
WHERE u.userId = p.userId and u.dateLastPurchased = p.dateCreated 

--update credit consumed info
--DROP TABLE WebDeferredRev..TempJasoncreditConsumed

SELECT a.userId,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,0, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,1,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD1,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,1, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,2,c.dateLastPurchased)  THEN a.credits ELSE 0 END) AS creditConsumedD2,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,2, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,3,c.dateLastPurchased)  
    THEN a.credits ELSE 0 END) AS creditConsumedD3,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,3, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,4,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD4,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,4, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,5,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD5,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,5, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,6,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD6,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,6, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,7,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD7,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,7, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,8,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD8,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,8, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,9,c.dateLastPurchased)  THEN a
.credits ELSE 0 END) AS creditConsumedD9,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,9, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,10,c.dateLastPurchased)  THEN 
a.credits ELSE 0 END) AS creditConsumedD10,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,10, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,11,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD11,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,11, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,12,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD12,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,12, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,13,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD13,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,13, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,14,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD14,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,14, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,15,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD15,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,15, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,16,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD16,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,16, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,17,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD17,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,17, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,18,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD18,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,18, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,19,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD19,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,19, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,20,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD20,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,20, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,21,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD21,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,21, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,22,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD22,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,22, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,23,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD23,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,23, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,24,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD24,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,24, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,25,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD25,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,25, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,26,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD26,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,26, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,27,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD27,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,27, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,28,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD28,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,28, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,29,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD29,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,29, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,30,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD30,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,30, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,31,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD31,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,31, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,32,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD32,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,32, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,33,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD33,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,33, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,34,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD34,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,34, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,35,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD35,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,35, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,36,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD36,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,36, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,37,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD37,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,37, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,38,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD38,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,38, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,39,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD39,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,39, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,40,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD40,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,40, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,41,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD41,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,41, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,42,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD42,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,42, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,43,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD43,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,43, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,44,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD44,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,44, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,45,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD45,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,45, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,46,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD46,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,46, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,47,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD47,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,47, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,48,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD48,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,48, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,49,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD49,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,49, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,50,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD50,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,50, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,51,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD51,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,51, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,52,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD52,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,52, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,53,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD53,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,53, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,54,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD54,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,54, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,55,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD55,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,55, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,56,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD56,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,56, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,57,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD57,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,57, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,58,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD58,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,58, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,59,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD59,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,59, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,60,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD60,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,60, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,61,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD61,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,61, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,62,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD62,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,62, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,63,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD63,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,63, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,64,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD64,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,64, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,65,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD65,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,65, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,66,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD66,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,66, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,67,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD67,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,67, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,68,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD68,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,68, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,69,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD69,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,69, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,70,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD70,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,70, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,71,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD71,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,71, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,72,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD72,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,72, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,73,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD73,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,73, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,74,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD74,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,74, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,75,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD75,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,75, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,76,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD76,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,76, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,77,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD77,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,77, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,78,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD78,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,78, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,79,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD79,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,79, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,80,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD80,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,80, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,81,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD81,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,81, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,82,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD82,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,82, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,83,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD83,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,83, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,84,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD84,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,84, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,85,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD85,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,85, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,86,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD86,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,86, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,87,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD87,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,87, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,88,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD88,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,88, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,89,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD89,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,89, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,90,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD90,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,90, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,91,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD91,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,91, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,92,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD92,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,92, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,93,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD93,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,93, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,94,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD94,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,94, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,95,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD95,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,95, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,96,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD96,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,96, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,97,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD97,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,97, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,98,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD98,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,98, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,99,c.dateLastPurchased)  THEN
 a.credits ELSE 0 END) AS creditConsumedD99,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,99, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,100,c.dateLastPurchased)  THE
N a.credits ELSE 0 END) AS creditConsumedD100,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,100, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,101,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD101,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,101, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,102,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD102,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,102, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,103,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD103,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,103, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,104,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD104,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,104, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,105,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD105,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,105, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,106,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD106,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,106, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,107,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD107,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,107, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,108,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD108,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,108, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,109,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD109,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,109, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,110,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD110,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,110, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,111,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD111,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,111, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,112,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD112,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,112, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,113,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD113,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,113, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,114,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD114,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,114, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,115,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD115,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,115, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,116,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD116,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,116, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,117,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD117,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,117, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,118,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD118,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,118, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,119,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD119,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,119, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,120,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD120,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,120, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,121,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD121,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,121, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,122,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD122,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,122, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,123,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD123,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,123, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,124,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD124,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,124, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,125,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD125,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,125, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,126,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD126,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,126, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,127,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD127,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,127, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,128,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD128,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,128, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,129,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD129,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,129, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,130,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD130,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,130, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,131,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD131,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,131, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,132,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD132,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,132, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,133,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD133,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,133, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,134,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD134,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,134, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,135,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD135,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,135, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,136,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD136,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,136, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,137,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD137,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,137, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,138,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD138,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,138, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,139,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD139,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,139, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,140,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD140,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,140, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,141,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD141,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,141, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,142,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD142,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,142, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,143,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD143,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,143, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,144,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD144,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,144, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,145,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD145,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,145, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,146,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD146,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,146, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,147,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD147,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,147, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,148,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD148,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,148, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,149,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD149,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,149, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,150,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD150,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,150, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,151,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD151,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,151, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,152,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD152,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,152, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,153,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD153,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,153, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,154,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD154,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,154, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,155,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD155,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,155, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,156,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD156,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,156, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,157,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD157,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,157, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,158,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD158,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,158, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,159,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD159,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,159, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,160,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD160,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,160, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,161,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD161,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,161, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,162,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD162,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,162, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,163,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD163,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,163, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,164,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD164,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,164, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,165,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD165,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,165, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,166,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD166,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,166, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,167,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD167,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,167, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,168,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD168,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,168, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,169,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD169,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,169, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,170,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD170,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,170, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,171,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD171,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,171, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,172,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD172,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,172, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,173,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD173,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,173, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,174,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD174,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,174, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,175,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD175,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,175, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,176,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD176,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,176, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,177,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD177,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,177, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,178,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD178,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,178, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,179,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD179,
    SUM(CASE WHEN a.dateCreated >= dateadd(dd,179, c.dateLastPurchased)  and a.dateCreated < dateadd(dd,180,c.dateLastPurchased)  TH
EN a.credits ELSE 0 END) AS creditConsumedD180
INTO wp_report..TempJasoncreditConsumed
FROM wp_report..TempJasonPositiveChart c, wp_report..AccountTransaction a 
WHERE  a.userId  = c.userId 
    and a.creditTypeId = 1 -- regular credit 
    and a.xactionTypeId >= 1 and a.xactionTypeId <= 4 --consumption
    and a.dateCreated < "feb 1 2004"
GROUP BY a.userId 

--================== unique index on userId
CREATE UNIQUE NONCLUSTERED INDEX idx_userId
    ON dbo.TempJasoncreditConsumed(userId)
go
IF EXISTS (SELECT * FROM sysindexes WHERE id=OBJECT_ID('dbo.TempJasoncreditConsumed') AND name='idx_userId')
    PRINT '<<< CREATED INDEX dbo.TempJasoncreditConsumed.idx_userId >>>'
ELSE
    PRINT '<<< FAILED CREATING INDEX dbo.TempJasoncreditConsumed.idx_userId >>>'
go

--=============update credit consumed ===========
update wp_report..TempJasonPositiveChart
set 
    c.creditConsumedD1 = a.creditConsumedD1,
    c.creditConsumedD2 = a.creditConsumedD2,
    c.creditConsumedD3 = a.creditConsumedD3,
    c.creditConsumedD4 = a.creditConsumedD4,
    c.creditConsumedD5 = a.creditConsumedD5,
    c.creditConsumedD6 = a.creditConsumedD6,
    c.creditConsumedD7 = a.creditConsumedD7,
    c.creditConsumedD8 = a.creditConsumedD8,
    c.creditConsumedD9 = a.creditConsumedD9,
    c.creditConsumedD10 = a.creditConsumedD10,
    c.creditConsumedD11 = a.creditConsumedD11,
    c.creditConsumedD12 = a.creditConsumedD12,
    c.creditConsumedD13 = a.creditConsumedD13,
    c.creditConsumedD14 = a.creditConsumedD14,
    c.creditConsumedD15 = a.creditConsumedD15,
    c.creditConsumedD16 = a.creditConsumedD16,
    c.creditConsumedD17 = a.creditConsumedD17,
    c.creditConsumedD18 = a.creditConsumedD18,
    c.creditConsumedD19 = a.creditConsumedD19,
    c.creditConsumedD20 = a.creditConsumedD20,
    c.creditConsumedD21 = a.creditConsumedD21,
    c.creditConsumedD22 = a.creditConsumedD22,
    c.creditConsumedD23 = a.creditConsumedD23,
    c.creditConsumedD24 = a.creditConsumedD24,
    c.creditConsumedD25 = a.creditConsumedD25,
    c.creditConsumedD26 = a.creditConsumedD26,
    c.creditConsumedD27 = a.creditConsumedD27,
    c.creditConsumedD28 = a.creditConsumedD28,
    c.creditConsumedD29 = a.creditConsumedD29,
    c.creditConsumedD30 = a.creditConsumedD30,
    c.creditConsumedD31 = a.creditConsumedD31,
    c.creditConsumedD32 = a.creditConsumedD32,
    c.creditConsumedD33 = a.creditConsumedD33,
    c.creditConsumedD34 = a.creditConsumedD34,
    c.creditConsumedD35 = a.creditConsumedD35,
    c.creditConsumedD36 = a.creditConsumedD36,
    c.creditConsumedD37 = a.creditConsumedD37,
    c.creditConsumedD38 = a.creditConsumedD38,
    c.creditConsumedD39 = a.creditConsumedD39,
    c.creditConsumedD40 = a.creditConsumedD40,
    c.creditConsumedD41 = a.creditConsumedD41,
    c.creditConsumedD42 = a.creditConsumedD42,
    c.creditConsumedD43 = a.creditConsumedD43,
    c.creditConsumedD44 = a.creditConsumedD44,
    c.creditConsumedD45 = a.creditConsumedD45,
    c.creditConsumedD46 = a.creditConsumedD46,
    c.creditConsumedD47 = a.creditConsumedD47,
    c.creditConsumedD48 = a.creditConsumedD48,
    c.creditConsumedD49 = a.creditConsumedD49,
    c.creditConsumedD50 = a.creditConsumedD50,
    c.creditConsumedD51 = a.creditConsumedD51,
    c.creditConsumedD52 = a.creditConsumedD52,
    c.creditConsumedD53 = a.creditConsumedD53,
    c.creditConsumedD54 = a.creditConsumedD54,
    c.creditConsumedD55 = a.creditConsumedD55,
    c.creditConsumedD56 = a.creditConsumedD56,
    c.creditConsumedD57 = a.creditConsumedD57,
    c.creditConsumedD58 = a.creditConsumedD58,
    c.creditConsumedD59 = a.creditConsumedD59,
    c.creditConsumedD60 = a.creditConsumedD60,
    c.creditConsumedD61 = a.creditConsumedD61,
    c.creditConsumedD62 = a.creditConsumedD62,
    c.creditConsumedD63 = a.creditConsumedD63,
    c.creditConsumedD64 = a.creditConsumedD64,
    c.creditConsumedD65 = a.creditConsumedD65,
    c.creditConsumedD66 = a.creditConsumedD66,
    c.creditConsumedD67 = a.creditConsumedD67,
    c.creditConsumedD68 = a.creditConsumedD68,
    c.creditConsumedD69 = a.creditConsumedD69,
    c.creditConsumedD70 = a.creditConsumedD70,
    c.creditConsumedD71 = a.creditConsumedD71,
    c.creditConsumedD72 = a.creditConsumedD72,
    c.creditConsumedD73 = a.creditConsumedD73,
    c.creditConsumedD74 = a.creditConsumedD74,
    c.creditConsumedD75 = a.creditConsumedD75,
    c.creditConsumedD76 = a.creditConsumedD76,
    c.creditConsumedD77 = a.creditConsumedD77,
    c.creditConsumedD78 = a.creditConsumedD78,
    c.creditConsumedD79 = a.creditConsumedD79,
    c.creditConsumedD80 = a.creditConsumedD80,
    c.creditConsumedD81 = a.creditConsumedD81,
    c.creditConsumedD82 = a.creditConsumedD82,
    c.creditConsumedD83 = a.creditConsumedD83,
    c.creditConsumedD84 = a.creditConsumedD84,
    c.creditConsumedD85 = a.creditConsumedD85,
    c.creditConsumedD86 = a.creditConsumedD86,
    c.creditConsumedD87 = a.creditConsumedD87,
    c.creditConsumedD88 = a.creditConsumedD88,
    c.creditConsumedD89 = a.creditConsumedD89,
    c.creditConsumedD90 = a.creditConsumedD90,
    c.creditConsumedD91 = a.creditConsumedD91,
    c.creditConsumedD92 = a.creditConsumedD92,
    c.creditConsumedD93 = a.creditConsumedD93,
    c.creditConsumedD94 = a.creditConsumedD94,
    c.creditConsumedD95 = a.creditConsumedD95,
    c.creditConsumedD96 = a.creditConsumedD96,
    c.creditConsumedD97 = a.creditConsumedD97,
    c.creditConsumedD98 = a.creditConsumedD98,
    c.creditConsumedD99 = a.creditConsumedD99,
    c.creditConsumedD100 = a.creditConsumedD100,
    c.creditConsumedD101 = a.creditConsumedD101,
    c.creditConsumedD102 = a.creditConsumedD102,
    c.creditConsumedD103 = a.creditConsumedD103,
    c.creditConsumedD104 = a.creditConsumedD104,
    c.creditConsumedD105 = a.creditConsumedD105,
    c.creditConsumedD106 = a.creditConsumedD106,
    c.creditConsumedD107 = a.creditConsumedD107,
    c.creditConsumedD108 = a.creditConsumedD108,
    c.creditConsumedD109 = a.creditConsumedD109,
    c.creditConsumedD110 = a.creditConsumedD110,
    c.creditConsumedD111 = a.creditConsumedD111,
    c.creditConsumedD112 = a.creditConsumedD112,
    c.creditConsumedD113 = a.creditConsumedD113,
    c.creditConsumedD114 = a.creditConsumedD114,
    c.creditConsumedD115 = a.creditConsumedD115,
    c.creditConsumedD116 = a.creditConsumedD116,
    c.creditConsumedD117 = a.creditConsumedD117,
    c.creditConsumedD118 = a.creditConsumedD118,
    c.creditConsumedD119 = a.creditConsumedD119,
    c.creditConsumedD120 = a.creditConsumedD120,
    c.creditConsumedD121 = a.creditConsumedD121,
    c.creditConsumedD122 = a.creditConsumedD122,
    c.creditConsumedD123 = a.creditConsumedD123,
    c.creditConsumedD124 = a.creditConsumedD124,
    c.creditConsumedD125 = a.creditConsumedD125,
    c.creditConsumedD126 = a.creditConsumedD126,
    c.creditConsumedD127 = a.creditConsumedD127,
    c.creditConsumedD128 = a.creditConsumedD128,
    c.creditConsumedD129 = a.creditConsumedD129,
    c.creditConsumedD130 = a.creditConsumedD130,
    c.creditConsumedD131 = a.creditConsumedD131,
    c.creditConsumedD132 = a.creditConsumedD132,
    c.creditConsumedD133 = a.creditConsumedD133,
    c.creditConsumedD134 = a.creditConsumedD134,
    c.creditConsumedD135 = a.creditConsumedD135,
    c.creditConsumedD136 = a.creditConsumedD136,
    c.creditConsumedD137 = a.creditConsumedD137,
    c.creditConsumedD138 = a.creditConsumedD138,
    c.creditConsumedD139 = a.creditConsumedD139,
    c.creditConsumedD140 = a.creditConsumedD140,
    c.creditConsumedD141 = a.creditConsumedD141,
    c.creditConsumedD142 = a.creditConsumedD142,
    c.creditConsumedD143 = a.creditConsumedD143,
    c.creditConsumedD144 = a.creditConsumedD144,
    c.creditConsumedD145 = a.creditConsumedD145,
    c.creditConsumedD146 = a.creditConsumedD146,
    c.creditConsumedD147 = a.creditConsumedD147,
    c.creditConsumedD148 = a.creditConsumedD148,
    c.creditConsumedD149 = a.creditConsumedD149,
    c.creditConsumedD150 = a.creditConsumedD150,
    c.creditConsumedD151 = a.creditConsumedD151,
    c.creditConsumedD152 = a.creditConsumedD152,
    c.creditConsumedD153 = a.creditConsumedD153,
    c.creditConsumedD154 = a.creditConsumedD154,
    c.creditConsumedD155 = a.creditConsumedD155,
    c.creditConsumedD156 = a.creditConsumedD156,
    c.creditConsumedD157 = a.creditConsumedD157,
    c.creditConsumedD158 = a.creditConsumedD158,
    c.creditConsumedD159 = a.creditConsumedD159,
    c.creditConsumedD160 = a.creditConsumedD160,
    c.creditConsumedD161 = a.creditConsumedD161,
    c.creditConsumedD162 = a.creditConsumedD162,
    c.creditConsumedD163 = a.creditConsumedD163,
    c.creditConsumedD164 = a.creditConsumedD164,
    c.creditConsumedD165 = a.creditConsumedD165,
    c.creditConsumedD166 = a.creditConsumedD166,
    c.creditConsumedD167 = a.creditConsumedD167,
    c.creditConsumedD168 = a.creditConsumedD168,
    c.creditConsumedD169 = a.creditConsumedD169,
    c.creditConsumedD170 = a.creditConsumedD170,
    c.creditConsumedD171 = a.creditConsumedD171,
    c.creditConsumedD172 = a.creditConsumedD172,
    c.creditConsumedD173 = a.creditConsumedD173,
    c.creditConsumedD174 = a.creditConsumedD174,
    c.creditConsumedD175 = a.creditConsumedD175,
    c.creditConsumedD176 = a.creditConsumedD176,
    c.creditConsumedD177 = a.creditConsumedD177,
    c.creditConsumedD178 = a.creditConsumedD178,
    c.creditConsumedD179 = a.creditConsumedD179,
    c.creditConsumedD180 = a.creditConsumedD180 
FROM wp_report..TempJasonPositiveChart c, wp_report..TempJasoncreditConsumed a
WHERE  a.userId = c.userId 

--initial balance right after last purchase
select getdate()
go

update wp_report..TempJasonPositiveChart
set a.initialBalance = b.balance,
    a.creditLastPurchased = b.credits
from wp_report..TempJasonPositiveChart a (index idx_userId), wp_report..AccountTransaction b (index XIE1Covering)
where a.userId	= b.userId and a.dateLastPurchased = b.dateCreated and b.xactionTypeId = 6
go

select getdate()
go




   public final static String UNDERAGE_MEMBER_STATUS = "Y";
    public final static String INACTIVE_MEMBER_STATUS = "I";
    public final static String BANNED_MEMBER_STATUS = "V";
    public final static String SUSPENDED_MEMBER_STATUS = "S";
    public final static String DELETED_MEMBER_STATUS1 = "I";
    public final static String DELETED_MEMBER_STATUS2 = "J";
    public final static String ACTIVE_MEMBER_STATUS = "A";
    public final static String WRONG_GENDER_STATUS = "G";
    public final static String INACTIVE_EMAIL_VERIFY_STATUS = "E";

DELETE FROM WebDeferredRev..TempJasonPositiveChart where userStatus in ('5', 'Y', 'V', 'S') or initialBalance > 500
--9742 row(s) affected.


select 
    SUM(initialBalance)   AS initialBalance,
    SUM(creditConsumedD1) AS creditConsumedD1 ,
    SUM(creditConsumedD2) AS D2 ,
    SUM(creditConsumedD3) AS D3 ,
    SUM(creditConsumedD4) AS D4 ,
    SUM(creditConsumedD5) AS D5 ,
    SUM(creditConsumedD6) AS D6 ,
    SUM(creditConsumedD7) AS D7 ,
    SUM(creditConsumedD8) AS D8 ,
    SUM(creditConsumedD9) AS D9 ,
    SUM(creditConsumedD10) AS D10 ,
    SUM(creditConsumedD11) AS D11 ,
    SUM(creditConsumedD12) AS D12 ,
    SUM(creditConsumedD13) AS D13 ,
    SUM(creditConsumedD14) AS D14 ,
    SUM(creditConsumedD15) AS D15 ,
    SUM(creditConsumedD16) AS D16 ,
    SUM(creditConsumedD17) AS D17 ,
    SUM(creditConsumedD18) AS D18 ,
    SUM(creditConsumedD19) AS D19 ,
    SUM(creditConsumedD20) AS D20 ,
    SUM(creditConsumedD21) AS D21 ,
    SUM(creditConsumedD22) AS D22 ,
    SUM(creditConsumedD23) AS D23 ,
    SUM(creditConsumedD24) AS D24 ,
    SUM(creditConsumedD25) AS D25 ,
    SUM(creditConsumedD26) AS D26 ,
    SUM(creditConsumedD27) AS D27 ,
    SUM(creditConsumedD28) AS D28 ,
    SUM(creditConsumedD29) AS D29 ,
    SUM(creditConsumedD30) AS D30 ,
    SUM(creditConsumedD31) AS D31 ,
    SUM(creditConsumedD32) AS D32 ,
    SUM(creditConsumedD33) AS D33 ,
    SUM(creditConsumedD34) AS D34 ,
    SUM(creditConsumedD35) AS D35 ,
    SUM(creditConsumedD36) AS D36 ,
    SUM(creditConsumedD37) AS D37 ,
    SUM(creditConsumedD38) AS D38 ,
    SUM(creditConsumedD39) AS D39 ,
    SUM(creditConsumedD40) AS D40 ,
    SUM(creditConsumedD41) AS D41 ,
    SUM(creditConsumedD42) AS D42 ,
    SUM(creditConsumedD43) AS D43 ,
    SUM(creditConsumedD44) AS D44 ,
    SUM(creditConsumedD45) AS D45 ,
    SUM(creditConsumedD46) AS D46 ,
    SUM(creditConsumedD47) AS D47 ,
    SUM(creditConsumedD48) AS D48 ,
    SUM(creditConsumedD49) AS D49 ,
    SUM(creditConsumedD50) AS D50 ,
    SUM(creditConsumedD51) AS D51 ,
    SUM(creditConsumedD52) AS D52 ,
    SUM(creditConsumedD53) AS D53 ,
    SUM(creditConsumedD54) AS D54 ,
    SUM(creditConsumedD55) AS D55 ,
    SUM(creditConsumedD56) AS D56 ,
    SUM(creditConsumedD57) AS D57 ,
    SUM(creditConsumedD58) AS D58 ,
    SUM(creditConsumedD59) AS D59 ,
    SUM(creditConsumedD60) AS D60 ,
    SUM(creditConsumedD61) AS D61 ,
    SUM(creditConsumedD62) AS D62 ,
    SUM(creditConsumedD63) AS D63 ,
    SUM(creditConsumedD64) AS D64 ,
    SUM(creditConsumedD65) AS D65 ,
    SUM(creditConsumedD66) AS D66 ,
    SUM(creditConsumedD67) AS D67 ,
    SUM(creditConsumedD68) AS D68 ,
    SUM(creditConsumedD69) AS D69 ,
    SUM(creditConsumedD70) AS D70 ,
    SUM(creditConsumedD71) AS D71 ,
    SUM(creditConsumedD72) AS D72 ,
    SUM(creditConsumedD73) AS D73 ,
    SUM(creditConsumedD74) AS D74 ,
    SUM(creditConsumedD75) AS D75 ,
    SUM(creditConsumedD76) AS D76 ,
    SUM(creditConsumedD77) AS D77 ,
    SUM(creditConsumedD78) AS D78 ,
    SUM(creditConsumedD79) AS D79 ,
    SUM(creditConsumedD80) AS D80 ,
    SUM(creditConsumedD81) AS D81 ,
    SUM(creditConsumedD82) AS D82 ,
    SUM(creditConsumedD83) AS D83 ,
    SUM(creditConsumedD84) AS D84 ,
    SUM(creditConsumedD85) AS D85 ,
    SUM(creditConsumedD86) AS D86 ,
    SUM(creditConsumedD87) AS D87 ,
    SUM(creditConsumedD88) AS D88 ,
    SUM(creditConsumedD89) AS D89 ,
    SUM(creditConsumedD90) AS D90 ,
    SUM(creditConsumedD91) AS D91 ,
    SUM(creditConsumedD92) AS D92 ,
    SUM(creditConsumedD93) AS D93 ,
    SUM(creditConsumedD94) AS D94 ,
    SUM(creditConsumedD95) AS D95 ,
    SUM(creditConsumedD96) AS D96 ,
    SUM(creditConsumedD97) AS D97 ,
    SUM(creditConsumedD98) AS D98 ,
    SUM(creditConsumedD99) AS D99 ,
    SUM(creditConsumedD100) AS D100 ,
    SUM(creditConsumedD101) AS D101 ,
    SUM(creditConsumedD102) AS D102 ,
    SUM(creditConsumedD103) AS D103 ,
    SUM(creditConsumedD104) AS D104 ,
    SUM(creditConsumedD105) AS D105 ,
    SUM(creditConsumedD106) AS D106 ,
    SUM(creditConsumedD107) AS D107 ,
    SUM(creditConsumedD108) AS D108 ,
    SUM(creditConsumedD109) AS D109 ,
    SUM(creditConsumedD110) AS D110 ,
    SUM(creditConsumedD111) AS D111 ,
    SUM(creditConsumedD112) AS D112 ,
    SUM(creditConsumedD113) AS D113 ,
    SUM(creditConsumedD114) AS D114 ,
    SUM(creditConsumedD115) AS D115 ,
    SUM(creditConsumedD116) AS D116 ,
    SUM(creditConsumedD117) AS D117 ,
    SUM(creditConsumedD118) AS D118 ,
    SUM(creditConsumedD119) AS D119 ,
    SUM(creditConsumedD120) AS D120 ,
    SUM(creditConsumedD121) AS D121 ,
    SUM(creditConsumedD122) AS D122 ,
    SUM(creditConsumedD123) AS D123 ,
    SUM(creditConsumedD124) AS D124 ,
    SUM(creditConsumedD125) AS D125 ,
    SUM(creditConsumedD126) AS D126 ,
    SUM(creditConsumedD127) AS D127 ,
    SUM(creditConsumedD128) AS D128 ,
    SUM(creditConsumedD129) AS D129 ,
    SUM(creditConsumedD130) AS D130 ,
    SUM(creditConsumedD131) AS D131 ,
    SUM(creditConsumedD132) AS D132 ,
    SUM(creditConsumedD133) AS D133 ,
    SUM(creditConsumedD134) AS D134 ,
    SUM(creditConsumedD135) AS D135 ,
    SUM(creditConsumedD136) AS D136 ,
    SUM(creditConsumedD137) AS D137 ,
    SUM(creditConsumedD138) AS D138 ,
    SUM(creditConsumedD139) AS D139 ,
    SUM(creditConsumedD140) AS D140 ,
    SUM(creditConsumedD141) AS D141 ,
    SUM(creditConsumedD142) AS D142 ,
    SUM(creditConsumedD143) AS D143 ,
    SUM(creditConsumedD144) AS D144 ,
    SUM(creditConsumedD145) AS D145 ,
    SUM(creditConsumedD146) AS D146 ,
    SUM(creditConsumedD147) AS D147 ,
    SUM(creditConsumedD148) AS D148 ,
    SUM(creditConsumedD149) AS D149 ,
    SUM(creditConsumedD150) AS D150 ,
    SUM(creditConsumedD151) AS D151 ,
    SUM(creditConsumedD152) AS D152 ,
    SUM(creditConsumedD153) AS D153 ,
    SUM(creditConsumedD154) AS D154 ,
    SUM(creditConsumedD155) AS D155 ,
    SUM(creditConsumedD156) AS D156 ,
    SUM(creditConsumedD157) AS D157 ,
    SUM(creditConsumedD158) AS D158 ,
    SUM(creditConsumedD159) AS D159 ,
    SUM(creditConsumedD160) AS D160 ,
    SUM(creditConsumedD161) AS D161 ,
    SUM(creditConsumedD162) AS D162 ,
    SUM(creditConsumedD163) AS D163 ,
    SUM(creditConsumedD164) AS D164 ,
    SUM(creditConsumedD165) AS D165 ,
    SUM(creditConsumedD166) AS D166 ,
    SUM(creditConsumedD167) AS D167 ,
    SUM(creditConsumedD168) AS D168 ,
    SUM(creditConsumedD169) AS D169 ,
    SUM(creditConsumedD170) AS D170 ,
    SUM(creditConsumedD171) AS D171 ,
    SUM(creditConsumedD172) AS D172 ,
    SUM(creditConsumedD173) AS D173 ,
    SUM(creditConsumedD174) AS D174 ,
    SUM(creditConsumedD175) AS D175 ,
    SUM(creditConsumedD176) AS D176 ,
    SUM(creditConsumedD177) AS D177 ,
    SUM(creditConsumedD178) AS D178 ,
    SUM(creditConsumedD179) AS D179 ,
    SUM(creditConsumedD180) AS D180 
FROM WebDeferredRev..PositiveChartAsOf2004Feb01 
--where dateLastPurchased >= "apr 1 2003" and dateLastPurchased < "oct 1 2003" 
where dateLastPurchased >= "jan 1 2003" and dateLastPurchased < "jul 1 2003" 
--where dateLastPurchased >= "jul 1 2002" and dateLastPurchased < "jan 1 2003" 
--where dateLastPurchased >= "apr 1 2002" and dateLastPurchased < "oct 1 2002" 
--where dateLastPurchased >= "jan 1 2002" and dateLastPurchased < "jul 1 2002" 
--where dateLastPurchased >= "apr 1 2001" and dateLastPurchased < "oct 1 2001" 
--where dateLastPurchased >= "apr 1 2000" and dateLastPurchased < "oct 1 2000" 
--where dateLastPurchased >= "apr 1 1999" and dateLastPurchased < "oct 1 1999" 







