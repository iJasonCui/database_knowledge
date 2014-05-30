SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM succor_mini.sys.database_files

--ms sql 2000
SELECT DB_NAME() AS DatabaseName
 , name AS FileName
 , size/128.0 AS CurrentSizeOnDisk_MB
 , CAST(FILEPROPERTY(name, 'SpaceUsed') AS INT)/128.0 AS SpaceUsed_MB
 FROM dbo.sysfiles

--sp_helpdb succor_mini

--dump tran  succor_mini with no_log

--DBCC SHRINKFILE (succor_mini, 500) WITH NO_INFOMSGS
--DBCC SHRINKFILE (succor_log_mini, 50) WITH NO_INFOMSGS

--BACKUP DATABASE succor_mini to DISK = 'g:\tempdump\succor_mini.full.backup'

/*
truncate table [succor_mini].[audit].[tLoadFileHistory]
truncate table [succor_mini].[audit].[tLoadArchiveHistory]
truncate table [succor_mini].[audit].[tLoadTableHistory]
truncate table [succor_mini].[audit].[tLoadCubeHistory]
truncate table [succor_mini].[audit].[tLoadReportHistory]
truncate table [succor_mini].[dbo].[tOlapQueryLog]
truncate table [succor_mini].[audit].[tProcJournal]
truncate table [succor_mini].[audit].[tDDLLog]
truncate table [succor_mini].[audit].[tDeletedArchiveRows]
truncate table [succor_mini].[audit].[tDeletedTableRows]
*/
SELECT min([loadFileKey]), max([loadFileKey]) FROM [succor_mini].[audit].[tLoadFileHistory]
SELECT min([loadFileKey]), max([loadFileKey]) FROM [succor_mini].[audit].[tLoadFile]
SELECT min([createdDateTime]), max([createdDateTime]) FROM [succor_mini].[audit].[tLoadFileHistory]
--FROM [succor_mini].[audit].[tLoadFile]

SELECT 'EXECUTE sp_spaceused "' + TABLE_CATALOG + '.' + TABLE_SCHEMA + '.' + TABLE_NAME + '"'
FROM succor_mini.INFORMATION_SCHEMA.TABLES
where TABLE_TYPE = 'BASE TABLE' 
--and TABLE_SCHEMA = 'ivr' --'dbo' --'cm'