
       CREATE PROCEDURE dbo.bsp_DisplayJobbyGroupId @groupId int, @jobId int

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath,U.name as groupName, J.emailId,J.emailCondId,J.nagId

        FROM Job J,Groups BG, sysusers U 

                  

        WHERE J.ownerGroup = @groupId

              and J.jobId = @jobId

              and U.uid=BG.gid

              and U.uid=U.gid

              and BG.groupId=J.ownerGroup 

              --and BG.activeStatusInd = "Y"

                 

    END


 
/* ### DEFNCOPY: END OF DEFINITION */
