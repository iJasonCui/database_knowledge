SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM evolve_mini.sys.database_files

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM dbo.sysfiles

--sp_helpdb evolve_mini

--dump tran  evolve_mini with no_log

--DBCC SHRINKFILE (evolve_mini, 200) WITH NO_INFOMSGS
--DBCC SHRINKFILE (evolve_mini_log, 50) WITH NO_INFOMSGS

--BACKUP DATABASE evolve to DISK = 'g:\tempdump\evolve_mini.full.backup'
--BACKUP DATABASE evolve_mini to DISK = 'g:\tempdump\evolve_mini.full.backup'

/* 
--backup from evolve and then restore to different db evolve_mini 

RESTORE DATABASE [evolve_mini] 
FROM  DISK = N'G:\TempDump\evolve_mini.full.backup' 
WITH  FILE = 1,  MOVE N'evolve' TO N'H:\MiniData\evolve_mini.mdf',  
MOVE N'evolve_log' TO N'H:\MiniData\evolve_mini_log.ldf',  NOUNLOAD,  REPLACE,  STATS = 10

*/

/*
truncate table [evolve_mini].[audit].[tLoadFileHistory]
truncate table [evolve_mini].[audit].[tLoadArchiveHistory]
truncate table [evolve_mini].[audit].[tLoadTableHistory]
truncate table [evolve_mini].[audit].[tLoadCubeHistory]
truncate table [evolve_mini].[audit].[tLoadReportHistory]
truncate table [evolve_mini].[dbo].[tOlapQueryLog]
truncate table [evolve_mini].[audit].[tProcJournal]
truncate table [evolve_mini].[audit].[tDDLLog]
truncate table [evolve_mini].[audit].[tDeletedArchiveRows]
truncate table [evolve_mini].[audit].[tDeletedTableRows]
*/
SELECT min([loadFileKey]), max([loadFileKey]) FROM [evolve_mini].[audit].[tLoadFileHistory]
SELECT min([loadFileKey]), max([loadFileKey]) FROM [evolve_mini].[audit].[tLoadFile]
SELECT min([createdDateTime]), max([createdDateTime]) FROM [evolve_mini].[audit].[tLoadFileHistory]
--FROM [evolve_mini].[audit].[tLoadFile]

SELECT 'EXECUTE sp_spaceused "' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '"'
FROM evolve_mini.INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE' 
and TABLE_SCHEMA = --'ivr' 
'dim' --'mobile' --'dbo' --'cm'