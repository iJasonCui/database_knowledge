select getdate()
set statistics io, time on 
select count(*) from Mobile..Carriercommunication_0r
select getdate()

/*
3/22/2010 9:09:10.726 AM

16825498
Table: Carriercommunication_0r scan count 1, logical reads: (regular=2065210 apf=0 total=2065210), physical reads: (regular=0 apf=0 total=0), apf IOs used=0
Total writes for this command: 0

Execution Time 55.
Adaptive Server cpu time: 5500 ms.  Adaptive Server elapsed time: 5440 ms.


3/22/2010 9:09:16.176 AM
*/


--physical IO
/*
3/22/2010 3:09:49.060 PM

16825498
Table: Mobile..Carriercommunication_0r scan count 1, logical reads: (regular=2065210 apf=0 total=2065210), 
physical reads: (regular=986558 apf=1078691 total=2065249), apf IOs used=1078652


regular=125151 apf=0 total=125151), physical reads: (regular=8 apf=15789 total=15797

Execution Time 1848.
Adaptive Server cpu time: 184800 ms.  Adaptive Server elapsed time: 188673 ms.


3/22/2010 3:12:57.740 PM

*/

/*
3/23/2010 11:07:34.440 AM

16825498
Table: Mobile..Carriercommunication_0r scan count 1, logical reads: (regular=2065210 apf=0 total=2065210), 
physical reads: (regular=648720 apf=1416529 total=2065249), apf IOs used=1416490
Total writes for this command: 0

Execution Time 2012.
Adaptive Server cpu time: 201200 ms.  Adaptive Server elapsed time: 204176 ms.

3/23/2010 11:10:58.616 AM
*/
