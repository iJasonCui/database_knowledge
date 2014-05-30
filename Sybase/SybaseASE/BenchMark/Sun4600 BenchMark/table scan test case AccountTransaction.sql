set showplan on
set statistics io,time on

select getdate()
select count(*) from AccountTransaction
select getdate()

/*
3/23/2010 10:52:03.596 AM

47670935
Table: AccountTransaction scan count 1, logical reads: (regular=358429 apf=0 total=358429), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Total writes for this command: 0

Execution Time 99.
Adaptive Server cpu time: 9900 ms.  Adaptive Server elapsed time: 9896 ms.


3/23/2010 10:52:13.493 AM

*/

