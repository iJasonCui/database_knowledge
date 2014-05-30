 CREATE PROCEDURE dbo.bsp_SelectFromJob2 
AS
    BEGIN
        SELECT 
        jobId,jobTypeId,jobName,
        jobDesc,createdBy,dateCreated,
        modifiedBy,dateModified,scriptname,
        activeStatusInd,expectedDuration,delayBeforeAlarm,
        ownerGroup,scriptPath  FROM Job
    END

/* ### DEFNCOPY: END OF DEFINITION */
