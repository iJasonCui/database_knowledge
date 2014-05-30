create proc bsp_MonitorAlert
AS

DECLARE @sec int

SELECT @sec = 60

SELECT CASE WHEN DATEDIFF(ss,dateLastRun,getdate()) <= @sec THEN 'Y' ELSE 'N' END AS AlertInd
FROM AlertMonitor

RETURN
 
/* ### DEFNCOPY: END OF DEFINITION */
