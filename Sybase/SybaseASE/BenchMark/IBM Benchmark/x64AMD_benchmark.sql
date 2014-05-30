[test 1 bcp in]

--case 1: c151iqdb2ASE internal disk x64 AMD Sybase 15
42 million rows took 13 minutes

--case 2: c151iqdb2ASE netapp disk x64 amd sybase 15 
42 million rows took 12 minutes

--case 3: w104dbr05  v880 sparc sybase 12.5

[test 2 create index]


select getdate()
CREATE UNIQUE NONCLUSTERED INDEX XAK1AccountTransaction
    ON dbo.AccountTransaction(userId,dateCreated,xactionId)
select getdate()
CREATE UNIQUE NONCLUSTERED INDEX XPKAccountTransaction
    ON dbo.AccountTransaction(xactionId)
select getdate()
CREATE NONCLUSTERED INDEX XAK2AccountTransaction
    ON dbo.AccountTransaction(dateCreated,xactionTypeId)
select getdate()

--case 1: c151iqdb2ASE internal disk x64 AMD Sybase 15
42 million rows took minutes

13/02/2009 10:10:31.843 PM
13/02/2009 10:20:46.540 PM  10mins
13/02/2009 10:26:07.903 PM  6 mins
13/02/2009 10:31:30.043 PM  5 mins

--case 2: c151iqdb2ASE netapp disk x64 amd sybase 15 
42 million rows took minutes

13/02/2009 10:36:15.990 PM
13/02/2009 10:49:14.096 PM  13 mins
13/02/2009 10:56:00.523 PM   7 mins
13/02/2009 11:03:38.803 PM   7 mins


--case 3: w151dbp04  v490 sparc sybase 15



[TEST 3] table scan 42 million rows
set showplan on
set statistics io,time on

select getdate()
select count(*) from AccountTransaction
select getdate()


--case 1: c151iqdb2ASE internal disk x64 AMD Sybase 15
42 million rows took minutes

13/02/2009 11:23:40.073 PM
42851724
Table: AccountTransaction scan count 1, logical reads: (regular=322194 apf=0 total=322194), physical reads: (regular=8 apf=40528 total=40536), apf IOs used=40528
Adaptive Server cpu time: 17600 ms.  Adaptive Server elapsed time: 17713 ms.

--cache 
13/02/2009 11:27:02.586 PM
42851724
Table: AccountTransaction scan count 1, logical reads: (regular=322194 apf=0 total=322194), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Adaptive Server cpu time: 16200 ms.  Adaptive Server elapsed time: 16060 ms.
13/02/2009 11:27:18.646 PM

--case 2: c151iqdb2ASE netapp disk x64 amd sybase 15 
42 million rows took minutes

13/02/2009 11:28:30.083 PM
42851724
Table: AccountTransaction scan count 1, logical reads: (regular=322194 apf=0 total=322194), physical reads: (regular=8 apf=40528 total=40536), apf IOs used=40528
Adaptive Server cpu time: 16400 ms.  Adaptive Server elapsed time: 79890 ms.
13/02/2009 11:29:49.973 PM

13/02/2009 11:31:49.506 PM
42851724
Table: AccountTransaction scan count 1, logical reads: (regular=322194 apf=0 total=322194), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Adaptive Server cpu time: 16100 ms.  Adaptive Server elapsed time: 16123 ms.
13/02/2009 11:32:05.630 PM

--case 3: w151dbp04  v490 sparc sybase 12.5

16/02/2009 9:30:18.223 PM
42491378
Table: AccountTransaction scan count 1, logical reads: (regular=319485 apf=0 total=319485), physical reads: (regular=8 apf=31571 total=31579), apf IOs used=31571
ime: 25700 ms.  Adaptive Server elapsed time: 26580 ms.
16/02/2009 9:30:44.806 PM

 
16/02/2009 9:24:45.010 PM
42491378
Table: AccountTransaction scan count 1, logical reads: (regular=319485 apf=0 total=319485), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Adaptive Server cpu time: 26200 ms.  Adaptive Server elapsed time: 25866 ms.
16/02/2009 9:25:10.876 PM


