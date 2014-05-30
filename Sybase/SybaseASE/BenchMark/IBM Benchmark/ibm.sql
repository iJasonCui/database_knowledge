select convert(varchar(40), getdate(), 109)

set showplan on
set statistics io,time on

select count(*) from Purchase_old

set showplan off 
set statistics io,time off

select convert(varchar(40), getdate(), 109) 

--===============
--t2000 m151dbp01 internal --62 secs 

Jan 29 2008  3:00:23:916PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=8 apf=22978 total=22986), apf IOs used=22973
Total writes for this command: 0

Execution Time 228.
SQL Server cpu time: 22800 ms.  SQL Server elapsed time: 61926 ms.
Total writes for this command: 0

Jan 29 2008  3:01:25:843PM

--======================================
--t2000 m151dbp01 netapp -- 120 secs 

Jan 29 2008  3:29:05:086PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=8 apf=22978 total=22986), apf IOs used=22973

Execution Time 229.
SQL Server cpu time: 22900 ms.  SQL Server elapsed time: 118013 ms.

Jan 29 2008  3:31:03:100PM

--==================================
--t2000 m151dbp01 NetApp 2nd run --24 secs 

Jan 29 2008  2:23:22:676PM

SQL Server cpu time: 0 ms.  SQL Server elapsed time: 6 ms.

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=23 apf=1388 total=1411), apf IOs used=1388

Execution Time 206.
SQL Server cpu time: 20600 ms.  SQL Server elapsed time: 24536 ms.

Jan 29 2008  2:23:47:220PM

--===================================
--t2000 m151dbp01 internal  --24 secs 

Jan 29 2008  2:25:49:110PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=8 apf=1452 total=1460), apf IOs used=1452

Execution Time 206.
SQL Server cpu time: 20600 ms.  SQL Server elapsed time: 22160 ms.

Jan 29 2008  2:26:11:270PM


--==============================================
-- Sun v490 w151dbp06   dsync off  internal disk   11 secs

Jan 29 2008  1:54:11:470PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=8 apf=15789 total=15797), apf IOs used=15787

Execution Time 65.
SQL Server cpu time: 6500 ms.  SQL Server elapsed time: 11340 ms.

Jan 29 2008  1:54:22:820PM

--===============================================
-- Sun v490 w151dbp06   dsync off  external disk   6 secs

Jan 29 2008  1:58:13:430PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=8 apf=15789 total=15797), apf IOs used=15787

Execution Time 58.
SQL Server cpu time: 5800 ms.  SQL Server elapsed time: 6283 ms.

Jan 29 2008  1:58:19:713PM

--================================
-- Sun v490 w151dbp06   dsync off  netapp   17 secs

Jan 29 2008  2:00:07:996PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=8 apf=15789 total=15797), apf IOs used=15787
Total writes for this command: 0

Execution Time 58.
SQL Server cpu time: 5800 ms.  SQL Server elapsed time: 16476 ms.
Total writes for this command: 0

Jan 29 2008  2:00:24:473PM

--=======================
--SUN V490 2nd run  6 seconds 

Jan 29 2008  2:01:23:360PM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Total writes for this command: 0

Execution Time 58.
SQL Server cpu time: 5800 ms.  SQL Server elapsed time: 5800 ms.
Total writes for this command: 0

Jan 29 2008  2:01:29:160PM


--=================================
--IBM 1 Internal disk  --10 secs

Jan 29 2008 11:00:06:176AM  

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=8 apf=15789 total=15797), apf IOs used=15787

Execution Time 68.
SQL Server cpu time: 6800 ms.  SQL Server elapsed time: 10576 ms.

Jan 29 2008 11:00:16:766AM

--===============================
--2nd run   4 secs

Jan 29 2008 11:06:47:413AM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=125151 apf=0 total=125151), physical reads: (regular=0 apf=0 total=0), apf IOs used=0

Execution Time 48.
SQL Server cpu time: 4800 ms.  SQL Server elapsed time: 4753 ms.
Total writes for this command: 0

Jan 29 2008 11:06:52:166AM

--=====================================
--IBM 1 NetApp  3min and 30 secs

Jan 29 2008 11:01:19:226AM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=8 apf=22978 total=22986), apf IOs used=22973
Total writes for this command: 0

Execution Time 66.
SQL Server cpu time: 6600 ms.  SQL Server elapsed time: 214780 ms.

Jan 29 2008 11:04:54:010AM

--=======================================
--second run   4 secs

Jan 29 2008 11:05:59:603AM

16770113
Table: Purchase_old scan count 1, logical reads: (regular=170203 apf=0 total=170203), physical reads: (regular=0 apf=0 total=0), apf IOs used=0


Execution Time 44.
SQL Server cpu time: 4400 ms.  SQL Server elapsed time: 4356 ms.

Jan 29 2008 11:06:03:960AM

--========================================

