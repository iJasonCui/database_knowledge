            CREATE PROCEDURE dbo.bsp_SelectJobsbyDateScheduledO @effectiveFrom DATETIME, @effectiveTo DATETIME
AS
    BEGIN

	    DECLARE @Tme datetime
    
    SELECT @Tme = convert(datetime,'Jan 1 1900 '+substring(convert(varchar(50),@effectiveTo,109),13,50))
    
    IF @Tme = convert(datetime,'Jan 1 1900')
        BEGIN
            SELECT @effectiveTo = dateadd(dd,1,@effectiveTo)
        END
    
     --SELECT  jobId ,max(executionId) as executionId
     --into #execut
     --     from Execution 
      --    WHERE dateCreated  >=  @dateCreatedFrom
     --     and dateCreated  <= @dateCreatedTo
      --    group by jobId
    
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath ,U2.name as groupName,
        S.effectiveFrom ,S.effectiveTo 
        
          FROM Job J, Groups BG,sysusers U2 , Schedule S
          WHERE 
              S.effectiveFrom <= @effectiveTo
          --and S.effectiveFrom <= 
          and S.effectiveTo  > @effectiveFrom
          --and S.effectiveTo <= @effectiveTo
          and BG.groupId=J.ownerGroup
          --and J.activeStatusInd = "Y"
          and U2.gid=BG.gid
          and J.jobId = S.jobId
          

           
         

        END

/* ### DEFNCOPY: END OF DEFINITION */
