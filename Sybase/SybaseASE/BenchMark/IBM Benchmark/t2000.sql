select convert(varchar(40), getdate(), 109)

set showplan on
set statistics io,time on
select count(*) from Purchase_old

select convert(varchar(40), getdate(), 109) 


 
Total writes for this command: 0

Execution Time 0.
SQL Server cpu time: 0 ms.  SQL Server elapsed time: 0 ms.


16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), 
physical reads: (regular=61 apf=22925 total=22986), apf IOs used=22920
Total writes for this command: 6

Execution Time 209.
SQL Server cpu time: 20900 ms.  
SQL Server elapsed time: 119030 ms.

--==============



Jan 24 2008  4:56:37:383PM
Total writes for this command: 0

Execution Time 0.
SQL Server cpu time: 0 ms.  SQL Server elapsed time: 0 ms.


16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Total writes for this command: 0

Execution Time 202.
SQL Server cpu time: 20200 ms.  SQL Server elapsed time: 20196 ms.


Jan 24 2008  4:56:57:580PM
Total writes for this command: 0

Execution Time 0.
SQL Server cpu time: 0 ms.  SQL Server elapsed time: 3 ms.

