
        CREATE PROCEDURE dbo.bsp_SelectJobsbyHostId @hostId int

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath ,U2.name as groupName,

        H.hostName,J.emailId,J.emailCondId,J.nagId 

        

          FROM Job J, Groups BG,sysusers U2,Host H WHERE J.hostId = @hostId

          and BG.groupId=J.ownerGroup

          and U2.gid=BG.gid

          and J.hostId=H.hostId

              

         

 

        END


 
/* ### DEFNCOPY: END OF DEFINITION */
