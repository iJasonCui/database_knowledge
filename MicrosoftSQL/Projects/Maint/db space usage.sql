--sp_helpdb  Succor

SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM Succor.sys.database_files

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM dbo.sysfiles

dump tran  Succor with no_log

--DBCC SHRINKFILE (BI2Log_Log, 500) WITH NO_INFOMSGS

--DBCC SHRINKFILE (succor, 30000) WITH NO_INFOMSGS

--sp_helpdb  athenaeum
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM sys.database_files

dump tran  Succor with no_log

--DBCC SHRINKFILE (BI2Log_Log, 500) WITH NO_INFOMSGS

--DBCC SHRINKFILE (succor, 30000) WITH NO_INFOMSGS