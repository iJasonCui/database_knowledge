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

--sp_helpdb Succor

--dump tran  Succor with no_log

--DBCC SHRINKFILE (succor, 20000) WITH NO_INFOMSGS

--truncate table [succor].[audit].[tLoadFileHistory]
--truncate table [succor].[audit].[tLoadArchiveHistory]
--truncate table [succor].[audit].[tLoadTableHistory]
--truncate table [succor].[audit].[tLoadCubeHistory]

SELECT min([loadFileKey]), max([loadFileKey]) FROM [succor].[audit].[tLoadFileHistory]
SELECT min([loadFileKey]), max([loadFileKey]) FROM [succor].[audit].[tLoadFile]
SELECT min([createdDateTime]), max([createdDateTime]) FROM [succor].[audit].[tLoadFileHistory]
--FROM [succor].[audit].[tLoadFile]