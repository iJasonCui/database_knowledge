--This query determines what monitoring tables are available:
select *
from master..monTables

--This query determines which parameters will improve performance by including them in a where clause:
select * from master..monTableParameters
where TableName="monOpenObjectActivity"

select ColumnName, TypeName, Length, Description
from master..monTableColumns
where TableName="monProcessSQLText"

select s.SPID, s.CpuTime, t.LineNumber, t.SQLText
from master..monProcessStatement s, master..monProcessSQLText t
where s.SPID = t.SPID
order by s.CpuTime DESC

select "Procedure Cache Hit Ratio" = (Requests-Loads)*100/Requests
from master..monProcedureCache
                   
select * into #moncache_prev
from master..monDataCache

waitfor delay "00:02:00"

select * into #moncache_cur
from master..monDataCache

select p.CacheName,
"Hit Ratio"=(c.LogicalReads-p.LogicalReads)*100 / (c.CacheSearches -
p.CacheSearches)
from #moncache_prev p, #moncache_cur c
where p.CacheName = c.CacheName

--This query creates a stored procedure that prints the executed SQL and the backtrace of any stored procedures for diagnostic purposes:
--create procedure sp_backtrace @spid int as
begin
select SQLText
from master..monProcessSQLText
where SPID=@spid
print "Stacktrace:"
select ContextID, DBName, OwnerName, ObjectName
from master..monProcessProcedures
where SPID=@spid
end

--Identifies any indices that are not currently in use and can be dropped:
select DBID, ObjectID, LastUsedDate, UsedCount
from monOpenObjectActivity
where DBID=1 --and ObjectID=1424005073 
and IndexID > 1

select * from sysindexes where indid > 1
