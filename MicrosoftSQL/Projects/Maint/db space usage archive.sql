SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM archive.sys.database_files

sp_helpdb archive

dump tran  archive with no_log

archive	archive	82500.000000	67199.875000
archive	archive_log	2321.375000	95.687500
archive	archive2	100000.000000	87494.062500
archive	archive3	41940.000000	14604.562500
archive	archive4	75000.000000	67550.000000
archive	archive5	75000.000000	67261.625000
--sep 4 2012
archive	archive	132867.125000	110209.125000
archive	archive_log	3089.875000	50.085937
archive	archive2	100000.000000	75616.937500
archive	archive3	41940.000000	14604.562500
archive	archive4	75000.000000	74999.312500
archive	archive5	75000.000000	71450.812500
--sep 5 2012
archive	archive	132867.125000	110382.875000
archive	archive_log	3089.875000	51.054687
archive	archive2	100000.000000	72869.687500
archive	archive3	41940.000000	14176.312500
archive	archive4	75000.000000	66025.687500
archive	archive5	75000.000000	70029.375000

select min(loadArchiveKey) from archive.ivr.Mailbox
--64368

select min(loadArchiveKey) from archive.ivr.CallLog
select count(*) from archive.ivr.CallLog where loadArchiveKey = 0

declare @loop_count int
select @loop_count = 100
DECLARE @min_loadArchiveKey int
while @loop_count > 0
begin
   set rowcount 100000
   delete from archive.ivr.CallLog where loadArchiveKey = 0
   select @loop_count = @loop_count - 1
end

declare @loop_count int
select @loop_count = 1000
DECLARE @min_loadArchiveKey int
while @loop_count > 0
begin
   select @min_loadArchiveKey = min(loadArchiveKey) from archive.ivr.CallLog
   --insert arch_archive.ivr.CallLog select * from archive.ivr.CallLog where loadArchiveKey = @min_loadArchiveKey
   delete from archive.ivr.CallLog where loadArchiveKey = @min_loadArchiveKey
   select @loop_count = @loop_count - 1
end

select  min(loadArchiveKey) from archive.ivr.Mailbox
select  * from archive.ivr.Mailbox 
where loadArchiveKey in (select  min(loadArchiveKey) from archive.ivr.Mailbox)

declare @loop_count int
select @loop_count = 5000
DECLARE @min_loadArchiveKey int
while @loop_count > 0
begin
   select @min_loadArchiveKey = min(loadArchiveKey) from archive.ivr.Mailbox
   --insert arch_archive.ivr.Mailbox select * from archive.ivr.Mailbox where loadArchiveKey = @min_loadArchiveKey
   delete from archive.ivr.Mailbox where loadArchiveKey = @min_loadArchiveKey
   select @loop_count = @loop_count - 1
end


select * FROM archive.sys.database_files
select * FROM succor.sys.database_files

DBCC OPENTRAN(archive)

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM archive.dbo.sysfiles

--sp_helpdb archive

--dump tran  archive with no_log

--DBCC SHRINKFILE (archive_log, 1000) WITH NO_INFOMSGS

EXECUTE sp_spaceused 'archive.cm.ContentLog'
EXECUTE sp_spaceused 'archive.ivr.Mailbox'
--Mailbox	308,642,985  	166357968 KB	151803416 KB	8531024 KB	6023528 KB
--Mailbox	302,062,375  	164213136 KB	149794000 KB	8361312 KB	6057824 KB
--Mailbox	168,085,927  	127111760 KB	115766408 KB	4939368 KB	6405984 KB  --2012sep04
EXECUTE sp_spaceused 'archive.ivr.CallLog'
--CallLog	197887478  	73378216 KB	62563712 KB	4630016 KB	6184488 KB --2012sep04
EXECUTE sp_spaceused 'archive.ivr.Message'
--Message	18423451   	18272920 KB	15264168 KB	548384 KB	2460368 KB --2012sep04

SELECT 'EXECUTE sp_spaceused "' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '"'
FROM archive.INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE' and TABLE_SCHEMA = 'ivr' --'dbo' --'cm'


select min(loadArchiveKey) from archive.ivr.Mailbox
select max(loadArchiveKey) from archive.ivr.Mailbox
select * from archive.ivr.Mailbox where loadArchiveKey =  63185
--insert arch_archive.ivr.Mailbox select * from archive.ivr.Mailbox where loadArchiveKey =  63185
--delete from archive.ivr.Mailbox where loadArchiveKey =  63185

select min(loadArchiveKey) from archive.ivr.Message 
select * from archive.ivr.Message  where loadArchiveKey =  383976 --47708
select max(loadArchiveKey) from archive.ivr.Message 

--DBCC Checktable('archive.ivr.Message', REPAIR_ALLOW_DATA_LOSS)

--DBCC Checktable('archive.ivr.Message')
--truncate table [archive].[ivr].[Message]

select min(loadArchiveKey) from archive.ivr.CallLog
select min(createdDateTime), max(createdDateTime), count(*) from archive.ivr.CallLog  where loadArchiveKey = 0 --383837 --47708
select max(loadArchiveKey) from archive.ivr.CallLog