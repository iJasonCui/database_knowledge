stop
select s.name + '.' + o.name as table_object from sys.objects o join sys.schemas s on o.schema_id = s.schema_id where o.type = 'U'
select * from sys.schemas where type = 'U'
EXEC sp_spaceused N'mobile.Account'

select object_name(21575115)

EXEC sp_spaceused
drop table #TableObjects 
create table #TableObjects (tableObject nvarchar(128),[rows] char(11),reserved varchar(18),data varchar(18),index_size varchar(18),unused varchar(18))
insert #TableObjects
EXEC sp_spaceused N'mobile.CarrierCommunication3'


select count(*) from am.TRANSACT_ALL

use archive
go
EXEC sp_spaceused
go
use athenaeum
EXEC sp_spaceused
go
use acumen
go
EXEC sp_spaceused
go
use succor
go
EXEC sp_spaceused
go
use sandbox
go
EXEC sp_spaceused
go

DBCC SQLPERF 


USE UserDB;
GO
DBCC SHRINKFILE (DataFile1, 7);
GO

DBCC SQLPERF (LOGSPACE)

SELECT name ,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 AS AvailableSpaceInMB
FROM sys.database_files;

--tIvrSalesHistory	262122967  	57720160 KB	57709560 KB	416 KB	10184 KB	57720160
--tAggregator	95737982   	29757864 KB	12059664 KB	17685960 KB	12240 KB	29757864

drop table #TableObjects 
go
create table #TableObjects (tableObject nvarchar(128),[rows] char(11),reserved varchar(18),data varchar(18),index_size varchar(18),unused varchar(18))
go
        declare @table_object nvarchar(128) 
		DECLARE c1 CURSOR FOR
		select s.name + '.' + o.name as table_object from sys.objects o join sys.schemas s on o.schema_id = s.schema_id where o.type = 'U'
		OPEN c1
		FETCH NEXT FROM c1 INTO @table_object

		WHILE @@FETCH_STATUS = 0
		BEGIN
			insert #TableObjects
            EXEC sp_spaceused @table_object
			FETCH NEXT FROM c1 INTO @table_object
		END
		CLOSE c1
		DEALLOCATE c1
go
select *,convert(int,(left(reserved,len(reserved)-3))) from #TableObjects 
order by convert(int,(left(reserved,len(reserved)-3))) desc--convert(int,rows) desc


select datepart(year,dateCreated),count(*) from mobile.CarrierCommunication
group by datepart(year,dateCreated)

select * from mobile.CarrierCommunication
where 
loadArchiveKey = 0
dateCreated < 'jan 1 2008'

select min(dateCreated),max(dateCreated) from mobile.CarrierCommunication
where loadArchiveKey < 827

select count(*) ,66762254 from archive.ivr.MenuUsage m join succor.audit.tLoadArchive la on m.loadArchiveKey = la.loadArchiveKey
where la.objectKey = 147 and la.dateKey < 'jan 1 2009'


 and loadArchiveKey < 827
select * from succor.audit.tLoadArchive where objectKey = 16 and dateKey = 'jan 1 2008'


select datepart(year,dateKey),datepart(month,dateKey),count(*) from archive.mobile.CarrierCommunication c join succor.audit.tLoadArchive a on c.loadArchiveKey = a.loadArchiveKey
where a.objectKey = 16 and a.dateKey < 'jan 1 2009'
group by datepart(year,dateKey),datepart(month,dateKey)
order by datepart(year,dateKey),datepart(month,dateKey)


        declare @loadArchiveKey int,@counter int
		set @counter = 0
		DECLARE c1 CURSOR FOR
		select loadArchiveKey from succor.audit.tLoadArchive a where a.objectKey = 16 and a.dateKey >= 'feb 1 2008' and a.dateKey < 'jan 1 2009'
		OPEN c1
		FETCH NEXT FROM c1 INTO @loadArchiveKey

		WHILE @@FETCH_STATUS = 0
		BEGIN
			delete archive.mobile.CarrierCommunication where loadArchiveKey = @loadArchiveKey
			select @counter = @counter + @@rowcount 
			FETCH NEXT FROM c1 INTO @loadArchiveKey
		END
		CLOSE c1
		DEALLOCATE c1
select @counter


declare @d datetime
set @d ='jan 1 2008'
while @d < 'jan 1 2009'
begin
	DELETE mobile.SMS_IN_Filter where dateCreated < 'jan 1 2009'
	select @d = dateadd(day,1,@d)
	select @d 
end


select min(dateCreated) from archive.mobile.SMS_IN_Filter

--Where tables live
SELECT o.[name], o.[type], i.[name], i.[index_id], f.[name]
FROM sys.indexes i
INNER JOIN sys.filegroups f
ON i.data_space_id = f.data_space_id
INNER JOIN sys.all_objects o
ON i.[object_id] = o.[object_id]
WHERE o.[type] = 'U'
GO


$PARTITION (Transact-SQL) 



Using the Catalog Views
The following catalog views contain partitioning information at the database, table, and index level, and also information about individual partition functions and partition schemes.

To get information about individual partition functions 

sys.partition_functions (Transact-SQL) 


To get information about individual parameters of partition functions 

sys.partition_parameters (Transact-SQL) 


To get information about the boundary values of a partition function 

sys.partition_range_values (Transact-SQL) 


To get information about all the partition schemes in a database 

sys.partition_schemes (Transact-SQL) 


sys.data_spaces (Transact-SQL) 


To get information about individual partition schemes 

sys.destination_data_spaces (Transact-SQL) 


To get information about all the partitions in a database 

sys.partitions (Transact-SQL) 


To get partitioning information about a table or index 

select * from sys.tables where object_id = 625437302
select * from sys.indexes where object_id = 625437302
select * from sys.index_columns where object_id = 625437302
select * from sys.columns where object_id = 625437302

