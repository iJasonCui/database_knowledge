--April 2002
select a.*,b.unitBalance 
into temp_dr_web_Apr2002
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Apr2002 
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) 
from temp_dr_web_Apr2002 
--		1133803112	52538642	0.2158036578105

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.22 as deferredRevenue
into DeferredRevenueApr2002
from temp_dr_web_Apr2002
where unitBalance > 0
group by firstTranYearMonth

select firstTranYearMonth,balance, 0.22 as price, deferredRevenue from DeferredRevenueApr2002

--Mar 2002
select a.*,b.unitBalance 
into temp_dr_web_Mar2002
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Mar2002 
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) 
from temp_dr_web_Mar2002 
--1063064615	50238060	0.2116054272398

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.21 as deferredRevenue
into DeferredRevenueMar2002
from temp_dr_web_Mar2002
where unitBalance > 0
group by firstTranYearMonth

select firstTranYearMonth,balance, 0.21 as price, deferredRevenue from DeferredRevenueMar2002


--feb 2002
select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Feb2002 
where unitBalance > 0
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) from temp_dr_web_Feb2002
--986578996	46504103	0.2121488067407

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.21 as deferredRevenue
into DeferredRevenueFeb2002  
from temp_dr_web_Feb2002
where unitBalance > 0
group by firstTranYearMonth

select *, 0.21 as price from DeferredRevenueFeb2002  

--auditting Feb 2002
select * from temp_dr_web_Feb2002 where --unitBalance > 1000
unitBalance < -100

--jan 2002
select a.*,b.unitBalance 
into temp_dr_web_Jan2002
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Jan2002 
where unitBalance > 0
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) from temp_dr_web_Jan2002
--916775413	44156015	0.2076218637483

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.21 as deferredRevenue
into DeferredRevenueJan2002  
from temp_dr_web_Jan2002
where unitBalance > 0
group by firstTranYearMonth

select *, 0.21 as price from DeferredRevenueJan2002  


--dec 2001
select a.*,b.unitBalance 
into temp_dr_web_Dec2001
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Dec2001 
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) from temp_dr_web_Dec2001
--		859818777	42362173	0.2029685250093

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.20 as deferredRevenue
into DeferredRevenueDec2001
from temp_dr_web_Dec2001
where unitBalance > 0
group by firstTranYearMonth

select *, 0.20 as price from DeferredRevenueDec2001  

--nov 2001
select a.*,b.unitBalance 
into temp_dr_web_Nov2001
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Nov2001 
group by firstTranYearMonth

select sum(totalPrice),sum(unitQty),sum(totalPrice)*0.01/sum(unitQty) from temp_dr_web_Nov2001
--	810880247	41023100	0.1976643030390

select firstTranYearMonth,sum(unitBalance) as balance, sum(unitBalance)*0.20 as deferredRevenue
into DeferredRevenueNov2001
from temp_dr_web_Nov2001
where unitBalance > 0
group by firstTranYearMonth

select *, 0.20 as price from DeferredRevenueNov2001  

--oct 2001
select a.*,b.unitBalance 
into temp_dr_web_Oct2001
from temp_account_request a, temp_Balance_WEB b
where a.customerId = b.customerId 

select firstTranYearMonth,sum(unitBalance) 
from temp_dr_web_Oct2001 
group by firstTranYearMonth

