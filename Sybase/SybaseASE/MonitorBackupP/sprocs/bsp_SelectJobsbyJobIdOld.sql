  CREATE PROCEDURE dbo.bsp_SelectJobsbyJobIdOld @jobId int
AS
    BEGIN
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,convert(varchar(50),J.dateModified,109)as dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath,J.hostId,U.name as groupName    
        
          FROM Job J,             
         Groups BG, sysusers U 
                  
              WHERE J.jobId = @jobId
         
              and U.uid=BG.gid
              and U.uid=U.gid
              and BG.groupId=J.ownerGroup
              -- and BG.activeStatusInd = "Y"
              
         

        END
/* ### DEFNCOPY: END OF DEFINITION */
