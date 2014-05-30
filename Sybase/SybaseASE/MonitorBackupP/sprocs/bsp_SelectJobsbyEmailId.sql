
      CREATE PROCEDURE dbo.bsp_SelectJobsbyEmailId @emailId int

AS

    BEGIN

        SELECT 

        J.jobId,J.jobTypeId,J.jobName,

        J.jobDesc,J.createdBy,J.dateCreated,

        J.modifiedBy,J.dateModified,J.scriptname,

        J.activeStatusInd,J.expectedDuration,J.delayBeforeAlarm,

        J.ownerGroup,J.scriptPath ,U2.name as groupName,

                        H.hostName, J.emailId

        

          FROM Job J, Groups BG,sysusers U2, Host H WHERE

          J.emailId = @emailId

          and BG.groupId=J.ownerGroup

          and H.hostId=*J.hostId

          and U2.gid=BG.gid

              

         

 

        END


 

 
/* ### DEFNCOPY: END OF DEFINITION */
