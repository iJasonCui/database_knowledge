      CREATE PROCEDURE dbo.bsp_SelectJobsbyUserIdOld @userId int
AS
    BEGIN
        SELECT 
        J.jobId,J.jobTypeId,J.jobName,
        J.jobDesc,J.createdBy,J.dateCreated,
        J.modifiedBy,J.dateModified,J.scriptname,
        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,
        J.ownerGroup,J.scriptPath ,U2.name as groupName 
        
          FROM Job J, Groups BG,sysusers U2 WHERE J.createdBy = @userId
          and BG.groupId=J.ownerGroup
          -- and J.activeStatusInd = "Y"
          and U2.gid=BG.gid
              
         

        END
/* ### DEFNCOPY: END OF DEFINITION */
