               CREATE PROCEDURE dbo.bsp_SelectJobsbyExecutionTime @dateCreatedFrom DATETIME, @dateCreatedTo DATETIME
AS
    BEGIN

	    DECLARE @Tme datetime
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@dateCreatedTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @dateCreatedTo = dateadd(dd,1,@dateCreatedTo)
        END
    
     SELECT  jobId ,max(executionId) as executionId
     into #execut
          from Execution 
          WHERE dateCreated  >=  @dateCreatedFrom
          and dateCreated  <= @dateCreatedTo
          group by jobId
    
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath ,U2.name as groupName , E2.dateCreated as maxDateExecuted,
		H.hostName
        
          FROM Job J, Groups BG,sysusers U2 , #execut E1 , Execution E2,Host H
          WHERE 
          BG.groupId=J.ownerGroup
          and H.hostId=*J.hostId
          and U2.gid=BG.gid
          and J.jobId = E1.jobId
          and E1.executionId = E2.executionId

           
         

        END
/* ### DEFNCOPY: END OF DEFINITION */
