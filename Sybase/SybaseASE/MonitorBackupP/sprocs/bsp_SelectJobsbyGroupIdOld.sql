   CREATE PROCEDURE dbo.bsp_SelectJobsbyGroupIdOld @groupId int
AS
    BEGIN
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath,U.name as groupName    
        
          FROM Job J,             
         Groups BG, sysusers U 
                  
              WHERE J.ownerGroup = @groupId
         
              and U.uid=BG.gid
              and U.uid=U.gid
              and BG.groupId=J.ownerGroup
              --and BG.activeStatusInd = "Y"
              
         

        END
/* ### DEFNCOPY: END OF DEFINITION */
