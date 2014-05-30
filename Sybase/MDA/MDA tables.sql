/* webdb0p 's webstat
select * from parsed_sp_sysmon where Server = "webdb0r" and TimeString >= "jul 28 2005"
set rowcount 10
select count_time from active_session order by count_time desc
select count_time from session_stats order by count_time desc
*/

--MDA tables
select * from master..monTables

select * from monState

select EngineNumber, CPUTime, SystemCPUTime, UserCPUTime, Connections,ProcessesAffinitied, StartTime
from monEngine
where Status = "online"

EngineNumber	CPUTime	SystemCPUTime	UserCPUTime	Connections	ProcessesAffinitied	StartTime
0	74024	86	16	5	6	7/28/2005 1:15:05.576 PM
1	73863	82	31	5	4	7/28/2005 1:18:06.890 PM
2	73854	11	140	4	5	7/28/2005 1:18:07.003 PM
3	73845	87	36	6	12	7/28/2005 1:18:07.113 PM

EngineNumber	CPUTime	SystemCPUTime	UserCPUTime	Connections	ProcessesAffinitied	StartTime
0	74143	152	26	5	8	7/28/2005 1:15:05.576 PM
1	73982	134	49	5	5	7/28/2005 1:18:06.890 PM
2	73973	20	246	4	4	7/28/2005 1:18:07.003 PM
3	73964	151	53	5	11	7/28/2005 1:18:07.113 PM

EngineNumber	CPUTime	SystemCPUTime	UserCPUTime	Connections	ProcessesAffinitied	StartTime
0	75185	32	58	5	6	7/28/2005 1:15:05.576 PM
1	75024	23	69	6	4	7/28/2005 1:18:06.890 PM
2	75015	15	34	5	5	7/28/2005 1:18:07.003 PM
3	75005	29	61	5	12	7/28/2005 1:18:07.113 PM

EngineNumber	CPUTime	SystemCPUTime	UserCPUTime	Connections	ProcessesAffinitied	StartTime
0	75368	69	143	5	8	7/28/2005 1:15:05.576 PM
1	75207	52	147	6	3	7/28/2005 1:18:06.890 PM
2	75198	30	180	6	6	7/28/2005 1:18:07.003 PM
3	75188	56	131	4	11	7/28/2005 1:18:07.113 PM



select * --into tempdb..monOpenDatabases
from monOpenDatabases

select * from tempdb..monOpenDatabases

select * from monDataCache

select * from  monProcedureCache

select * from monCachedObject

select * from monCachedProcedures

drop table tempdb..monOpenObjectActivity
select * into tempdb..monOpenObjectActivity
from monOpenObjectActivity 

--drill down to db level
select d.name, m.* from tempdb..monOpenObjectActivity m, master..sysdatabases d
where m.DBID = d.dbid --and LogicalReads > 1000 
order by LogicalReads desc

--drill down to object level
select d.name, o.name, m.* from tempdb..monOpenObjectActivity m, master..sysdatabases d, Profile_ad..sysobjects o
where m.DBID = d.dbid --and LogicalReads > 1000 
and m.ObjectID = o.id and d.name = "Profile_ad"
--order by LogicalReads desc
order by UsedCount desc


--index usage
select "Database" = db_name(m.DBID), "Table" = object_name(m.ObjectID, m.DBID),
   IndID = m.IndexID, m.UsedCount, m.LastUsedDate, m.OptSelectCount, m.LastOptSelectDate , i.name
from master..monOpenObjectActivity m, Profile_ad..sysindexes i
where db_name(m.DBID) = "Profile_ad" 
  and i.id = m.ObjectID and i.indid = m.IndexID
order by  m.UsedCount desc --DBID, ObjectID,

exec sp_helpindex a_profile_dating

--hot table 
select * --into #t 
from  master..monOpenObjectActivity
select TableName = object_name(ObjectID, DBID), IndexID, LogicalReads, PhysicalReads, Operations, LockWaits
from #t
order by 1, 2

--=============== stored proc performance ========
--monSysStatement will be erased after reading 
select ProcName = isnull(object_name(ProcedureID, DBID), "UNKNOWN"),
       DBName   = isnull(db_name(DBID), "UNKNOWN"),
       ElapsedTime = datediff(ms, min(StartTime), max(EndTime))
from   master..monSysStatement
group by SPID, DBID, ProcedureID, BatchID
--having ProcedureID != 0        
order by 3 desc

select * from master..monSysStatement

wsp_getCitiesByCountryId

declare @countryId int 
select  @countryId = 244
/*
select City.cityId, jurisdictionId, secondJurisdictionId, cityName, latitudeRad, longitudeRad, tz.legacyName, loc_m
from City
   left join Timezone tz on tz.timezoneId = City.timezoneId and City.countryId = @countryId
   inner join Country on City.countryId = Country.countryId 
      and City.countryId = @countryId
      and Country.countryId = @countryId
   and City.population >= Country.minPopulation
*/
set rowcount 100
select c.cityId, c.jurisdictionId, c.secondJurisdictionId, c.cityName, c.latitudeRad, c.longitudeRad, tz.legacyName, c.loc_m
from Timezone tz, Country cn, City c -- (index IDX_2)
where tz.timezoneId = c.timezoneId and c.countryId = @countryId
  and c.countryId = cn.countryId 
  and cn.countryId = @countryId
  and c.population >= cn.minPopulation

select countryId, count(*) from City group by countryId
   
sp_helpindex City   

--=============procedure cache ==========
--sp_monitorconfig 'procedure cache size'

Name	Num_free	Num_active	Pct_act	Max_Used	Num_Reuse
procedure cache size	548	2723	 83.25	3278	20504

select Requests, Loads, "Ratio" = convert(numeric(5,2), (100 - (100* ((1.0*Loads)/Requests))))
from master..monProcedureCache

--==========
select * from monProcessSQLText