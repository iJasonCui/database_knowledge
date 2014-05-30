--truncate table [succor].[audit].[tLoadFileHistory]
--truncate table [succor].[audit].[tLoadArchiveHistory]
--truncate table [succor].[audit].[tLoadTableHistory]
--truncate table [succor].[audit].[tLoadCubeHistory]

SELECT min([loadFileKey]), max([loadFileKey])
FROM [succor].[audit].[tLoadFileHistory]

SELECT min([loadFileKey]), max([loadFileKey])
FROM [succor].[audit].[tLoadFile]


SELECT min([createdDateTime]), max([createdDateTime])
--FROM [succor].[audit].[tLoadFileHistory]
FROM [succor].[audit].[tLoadFile]