SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM acumen.sys.database_files

select * FROM acumen.sys.database_files
select * FROM succor.sys.database_files

DBCC OPENTRAN(acumen)

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM acumen.dbo.sysfiles

--sp_helpdb acumen

--dump tran  acumen with no_log

--DBCC SHRINKFILE (acumen_log, 5000) WITH NO_INFOMSGS

EXECUTE sp_spaceused 'acumen.cm.ContentLog'


SELECT 'EXECUTE sp_spaceused "' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '"'
FROM acumen.INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE' and TABLE_SCHEMA = 'ivr' --'dbo' --'cm'


select min(loadacumenKey) from acumen.ivr.Mailbox
select max(loadacumenKey) from acumen.ivr.Mailbox
select * from acumen.ivr.Mailbox where loadacumenKey =  384018

select min(loadacumenKey) from acumen.ivr.Message 
select * from acumen.ivr.Message  where loadacumenKey =  383976 --47708
select max(loadacumenKey) from acumen.ivr.Message 

--DBCC Checktable('acumen.ivr.Message', REPAIR_ALLOW_DATA_LOSS)

--DBCC Checktable('acumen.ivr.Message')
--truncate table [acumen].[ivr].[Message]

select min(loadacumenKey) from acumen.ivr.CallLog
select min(createdDateTime), max(createdDateTime), count(*) from acumen.ivr.CallLog  where loadacumenKey = 0 --383837 --47708
select max(loadacumenKey) from acumen.ivr.CallLog

--truncate table [acumen].[fact].[tFeatureDuration]