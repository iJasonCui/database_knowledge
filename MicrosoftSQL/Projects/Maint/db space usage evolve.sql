SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM evolve.sys.database_files

select * FROM evolve.sys.database_files
select * FROM succor.sys.database_files

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM evolve.dbo.sysfiles

--sp_helpdb evolve

--dump tran  evolve with no_log

--DBCC SHRINKFILE (evolve_log, 1000) WITH NO_INFOMSGS

SELECT 'EXECUTE sp_spaceused "' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '"'
FROM evolve.INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE' 
and TABLE_SCHEMA = 'dim' --'mobile' --'web'
--'ivr' 
--'dbo' --'cm'

