SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM athenaeum.sys.database_files

DBCC OPENTRAN(athenaeum)

EXEC sp_removedbreplication athenaeum

SELECT name, log_reuse_wait_desc FROM sys.databases 

select log_reuse_wait_desc,name from sys.databases

--sp_repldone null, null, 0,0,1

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM dbo.sysfiles

--sp_helpdb athenaeum

checkpoint
--backup log   athenaeum with no_log

dump tran  athenaeum with truncate_only

--DBCC SHRINKFILE (athenaeum_log, 5000) WITH NO_INFOMSGS
--DBCC SHRINKFILE (athenaeum2, 20000) WITH NO_INFOMSGS
--DBCC SHRINKFILE (athenaeum3, 40000) WITH NO_INFOMSGS

