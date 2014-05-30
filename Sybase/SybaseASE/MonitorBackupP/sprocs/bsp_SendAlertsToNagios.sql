   CREATE PROC bsp_SendAlertsToNagios
as
TRUNCATE TABLE AlertTemp
INSERT AlertTemp
SELECT 
     alertId
    ,alertNotes
    ,createdBy
    ,dateCreated
    ,jobId
    ,alertLevel
    ,executionId
    ,nagiosIndicator
    ,scheduleId

 FROM Alert 
WHERE nagiosIndicator = "N"

UPDATE Alert SET A.nagiosIndicator = "Y"  
FROM AlertTemp AA, Alert A  WHERE AA.nagiosIndicator = "N"
AND AA.alertId = A.alertId
/* ### DEFNCOPY: END OF DEFINITION */
