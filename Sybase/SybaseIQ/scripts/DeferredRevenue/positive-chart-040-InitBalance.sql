select getdate()
go

--Credit at last purchase
--UPDATE wp_report..TempJasonPositiveChart
--SET u.creditLastPurchased = p.credits
--FROM wp_report..TempJasonPositiveChart u (INDEX idx_userId), wp_report..AccountTransaction p (INDEX XIE1Covering)
--WHERE u.userId = p.userId and u.dateLastPurchased = p.dateCreated 
--go

select getdate()
go

--creditBalance right after last purchase
--select b.userId, sum(b.credits) as initialBalance
--into wp_report..JasonPositiveChart_Bal
--from wp_report..TempJasonPositiveChart a (index idx_userId), 
--     wp_report..AccountTransaction b (index XIE1Covering)
--where a.userId  = b.userId and a.dateLastPurchased >= b.dateCreated 
--  and b.creditTypeId = 1 -- regular credit                                                        
--  and b.xactionTypeId in (1,2,3,4,6,21,22,23,24,25,26,28) -- 1-4,21-26,28 are consumption, 6 is purchase 
--group by  b.userId
--go

select getdate()
go

create unique nonclustered index idx_userId on wp_report..JasonPositiveChart_Bal (userId)
go

select getdate()
go

UPDATE wp_report..TempJasonPositiveChart
SET u.initialBalance = p.initialBalance
FROM wp_report..TempJasonPositiveChart u (INDEX idx_userId), wp_report..JasonPositiveChart_Bal p (INDEX idx_userId)
WHERE u.userId = p.userId 
go

select getdate()
go

/*
select xactionTypeId, count(*)
from wp_report..AccountTransaction b (index XIE1Covering)
where creditTypeId = 1 -- regular credit                                                      
group by xactionTypeId

xactionTypeId	
0	253078
1	29641697
2	5408714
3	18088275
4	746061
6	3957178
7	899297
8	3237
9	439
11	378135
12	95611
13	21274
14	79647
17	19
21	21759
22	482437
23	448849
24	1792
25	39042
26	34146
28	17758

select xactionTypeId, count(*) as row_count, sum(credits) as credits
from wp_report..AccountTransaction b (index XIE1Covering)
group by xactionTypeId

xactionTypeId	row_count	credits
0	281614	-857841
1	30070915	-155671431
2	5753399	-57666393
3	18676428	-95321043
4	764432	-3959051
5	373457	0
6	3980485	342827147
7	913080	3050
8	3237	-539390
9	439	-46071
11	1286534	-28584716
12	136941	1455743
13	21790	158559
14	1350897	18300400
15	14603	334478
17	19	-38
21	21874	-21874
22	485088	-484926
23	450749	-901442
24	1792	-1792
25	39164	-39151
26	34197	-68392
28	18216	-109272
29	1556	0


xactionTypeId	description
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
18	processor refused
19	processor cancelled
20	processor charged back
21	IM extended session 1 minute fro
22	IM extended session 2 minutes fr
23	IM extended session 5 minutes fr
24	IM extended session 1 minute fro
25	IM extended session 2 minutes fr
26	IM extended session 5 minutes fr
28	PARTY 20 minutes IM session
29	UK Free Trial
30	Subscription Promo
31	Subscription Purchase
32	Subscription Renewal

*/
